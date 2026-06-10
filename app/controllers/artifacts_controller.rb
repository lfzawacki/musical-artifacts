class ArtifactsController < InheritedResources::Base
  load_and_authorize_resource except: [:download]
  load_resource only: [:download]
  before_action only: [:download] do
    authorize!(:download, @artifact) if !@artifact.approved?
  end

  # For API calls
  respond_to :json, :atom

  # For CDN caching purposes
  # Disable Set-Cookie and add cache headers for logged out users
  def set_cache_header
    response.headers["Cache-Control"] =
      "public, max-age=2592000, s-maxage=2592000"
  end

  before_filter only: [:index] do
    search_artifacts
    order_by_params
    load_tag_filters
    paginate
    set_index_caching
  end

  before_action only: [:show] do
    set_show_caching
  end

  before_filter :load_licenses, only: [:new, :edit, :create, :update]
  before_filter :load_app_integrations, only: [:index, :show]
  before_filter :load_max_tags, except: [:download]

  def create
    approved = can?(:approve, @artifact) || user_artifacts_can_be_approved?(current_user)
    @artifact.approved = approved
    @artifact.user = current_user

    if approved
      create!
    else
      create!(notice: I18n.t('artifacts.create.not_approved'))
    end
  end

  def download

    # TODO:
    # Using user params, is it dangerous? Not really if you understand that
    # get_file_by_name will only return file paths written to the database
    # BUT maybe there's some sanitization to be done here?
    file = @artifact.get_file_by_name(sanitize_filename_from_params)

    if file.present?
      set_cache_header

      # Cache if file hash is the same
      fresh_when etag: @artifact.file_hash, public: true

      # Don`t include cookie if file is public, important for cloudflare
      if @artifact.downloadable? && @artifact.approved?
        request.session_options[:skip] = true
      end

      file_params = { filename: file.name }

      # If mime type is registered for the file send it
      mime_type = Mime::Type.lookup_by_extension(file.format)
      file_params.merge!(type: mime_type) if mime_type.present?

      # Pathname is necessary for X-Send-File to work with Capistrano sym-links
      send_file Pathname(file.path).realdirpath, file_params

      file.increment_download_count
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end
  end

  private

    def set_index_caching
      # User Id (or anon) + locale + query + the artifact id + artifact update time
      etag = Digest::MD5.hexdigest(
        [
          current_user.try(:id) || 'anon',
          I18n.locale,
          params[:q],
          params[:page],
          params[:hash],
          params[:tags],
          params[:apps],
          params[:formats],
          params[:license],
          params[:order],
          params[:asc],
          @artifacts.map { |a| "#{a.id}-#{a.updated_at.to_i}" }.join("/")
        ].join("|")
      )

      fresh_when etag: etag, public: true
    end

    def set_show_caching
      # User Id (or anon) + locale + artifact id + artifact update time
      etag = [
        current_user.try(:id) || 'anon',
        I18n.locale,
        @artifact.id,
        @artifact.updated_at.to_i
      ]

      fresh_when etag, public: true
    end

    def artifact_params
      params.require(:artifact).permit(
        :name, :description, :author, :file, :license_id, :more_info_urls,
        :software_list, :tag_list, :file_format_list, :file_hash, :mirrors, :extra_license_text
      )
    end

    def search_artifacts
      @artifacts = Searches.new(
        Artifact.approved,
        params.permit(:hash, :tags, :apps, :formats, :license, :q)
      ).call.includes(:license)
    end

    def paginate
      @artifacts = @artifacts.page(params[:page]).per(@setting.artifacts_per_page)
    end

    def order_by_params
      order_str = params[:order]
      direction = params[:asc] ? 'ASC' : 'DESC'

      if ['top_rated', 'most_downloaded', 'name',
          'created_at', 'updated_at'].include?(order_str)
        # Change param names to the actual database names
        # This only make for better URLs in the end
        search_str = case order_str
        when 'top_rated'
          'favorite_count'
        when 'most_downloaded'
          'download_count'
        else
          order_str
        end

        @artifacts = @artifacts.order("artifacts.#{search_str} #{direction}")
      else
        # prevents page from showing arbitrary parameter
        params[:order] = 'created_at'
        @artifacts = @artifacts.order('artifacts.created_at DESC')
      end
    end

    def load_licenses
      @free_licenses = License.where(free: true).map(&:license_for_group_select).sort_by(&:first)
      @non_free_licenses = License.where(free: [false, nil]).map(&:license_for_group_select).sort_by(&:first)
    end

    def load_tag_filters
      @tags = {
        tags: @artifacts.tag_counts_on(:tags)
          .where('tags_count > ?', @setting.min_tag_search.to_i)
          .order('tags.taggings_count DESC')
          .limit(@setting.max_tag_results.to_i),
        apps: @artifacts.tag_counts_on(:software)
          .where('tags_count > ?', @setting.min_app_search.to_i)
          .order('tags.name ASC')
          .limit(@setting.max_app_results.to_i),
        formats: @artifacts.tag_counts_on(:file_formats)
          .where('tags_count > ?', @setting.min_format_search.to_i)
          .order('tags.name ASC')
          .limit(@setting.max_format_results.to_i)
      }
      @licenses = License.license_types - ['copyright', 'various', 'gray']
      @copyright = License.find('copyright') # always the black sheep
    end

    def sanitize_filename_from_params
      # Since users can input the 'filename' just reject dangerous stuff like './' and '../' paths
      filename = params[:filename].clone unless /(?:^|\/)[.]{1,2}(?:\/|$)|^\/.*/.match(params[:filename])
      filename
    end

    def handle_access_denied exception
      if request.format.json?
        head :unauthorized
      elsif [:edit, :update, :download].include?(exception.action)
        redirect_to artifact_path(@artifact), notice: t('_other.access_denied')
      elsif [:new].include?(exception.action)
        redirect_to new_user_session_path
      else
        redirect_to artifacts_path(), notice: t('_other.access_denied')
      end
    end

    # A user with a certain number of pre-approved won't need approval
    def user_artifacts_can_be_approved?(user)
      user.artifacts.where(approved: true).count >= Artifact.approved_count_for_trust
    end

    # Load an object with the max tags number for each type
    def load_max_tags
      @max_tags = {
        "tag" => @setting.max_artifact_tags.to_i,
        "app" => @setting.max_artifact_apps.to_i,
        "format" => @setting.max_artifact_formats.to_i,
      }
    end

    # Load app integrations if some are present
    # Used for notifications
    def load_app_integrations
      app_tags = @artifact.try(:software_list) || []
      app_tags.push(params[:apps]) if params[:apps].present?

      @app_integrations = App.tagged_with(app_tags, any: true).where(has_integration: true)
    end

    # Translate commas and spaces from url encoded values
    # back to their ascii counterparts
    def translate_url_encoded_params string
      [:hash, :tags, :apps, :formats, :license, :q].each do |param_name|
        if params[param_name].present?
          params[param_name] = params[param_name].gsub('%20',' ').gsub('%2C', ',')
        end
      end
    end
end
