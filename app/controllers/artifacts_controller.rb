class ArtifactsController < InheritedResources::Base
  load_and_authorize_resource except: [:download]
  load_resource only: [:download]

  before_action only: [:download] do
    authorize!(:download, @artifact) if !@artifact.approved?
  end

  # For API calls
  respond_to :json, :atom

  before_filter only: [:index] do
    search_artifacts
    load_tag_filters
    paginate unless request.format == 'json'
    order_by_params
  end

  before_filter :load_licenses, only: [:new, :edit, :create, :update]
  before_filter :load_app_integrations, only: [:index, :show]

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

    def artifact_params
      params.require(:artifact).permit(
        :name, :description, :author, :file, :license_id, :more_info_urls,
        :software_list, :tag_list, :file_format_list, :file_hash, :mirrors, :extra_license_text
      )
    end

    def search_params
      { hash: :with_hash, tags: :tagged_with, apps: :app_tagged_with,
        license: :licensed_as, formats: :with_file_format, q: :by_metadata }
    end


    def search_artifacts
      remove_duplicated_tags_from_searches # HACKY, read the comments above this method

      @artifacts = Artifact.approved
      search_params.each do |param, search|
        @artifacts = Searches.send("artifacts_#{search}", @artifacts, params[param])
      end
      @artifacts = @artifacts.includes(:license)
    end

    def paginate
      @artifacts = @artifacts.page(params[:page]).per(@setting.artifacts_per_page)
    end

    def order_by_params
      order_str = params[:order]
      direction = params[:asc] ? 'ASC' : 'DESC'

      if ['top_rated', 'most_downloaded', 'name', 'created_at'].include?(order_str)
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

        @artifacts = @artifacts.order("#{search_str} #{direction}")
      else
        # prevents page from showing arbitrary parameter
        params[:order] = 'created_at'
        @artifacts = @artifacts.order('created_at DESC')
      end
    end

    def load_licenses
      @free_licenses = License.where(free: true).map(&:license_for_group_select).sort_by(&:first)
      @non_free_licenses = License.where(free: false).map(&:license_for_group_select).sort_by(&:first)
    end

    def load_tag_filters
      @tags = {
        tags: @artifacts.tag_counts_on(:tags).order('taggings_count DESC').select{|tc| tc.count > 1},
        apps: @artifacts.tag_counts_on(:software).order('name ASC'),
        formats: @artifacts.tag_counts_on(:file_formats).order('name ASC')
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

    # Chaining acts_as_taggable_on searches like we're doing ends up with a
    # "PG::DuplicateAlias: ERROR: table name" if two tag categories are queried for the same value.
    # For example {'tags': 'sfz', 'formats': 'sfz'}
    # Generally this kind of search is not the most sensical, so we'll just remove one and try to make the right
    # choice, because the application breaks with a 500 error otherwise
    # TODO: there's probably some ruby magic that can be done to DRY this up
    def remove_duplicated_tags_from_searches
      tag_fields = [:q, :tags, :apps, :formats]
      counts = {}
      reversed = {}

      # count repetitions
      tag_fields.each do |key|

        if params[key].present?
          fields = params[key].split(/\s*,\s*/)
          fields.each do |field|
            reversed[field] ||= []
            counts[field] ||= 0

            reversed[field] += [key]
            counts[field] += 1
          end
        end
      end

      # delete repetitions from parameters
      counts.each do |val, count|
        if val != nil
          2.upto(count) do |i|
            Rails.logger.info " *** [PG::DuplicateAlias] deleting duplicated param #{reversed[val][i-1]}"
            fields = params[reversed[val][i-1]].split(/\s*,\s*/)
            fields.delete(val)
            params[reversed[val][i-1]] = fields.join(',')
          end
        end
      end
    end

    # A user with a certain number of pre-approved won't need approval
    def user_artifacts_can_be_approved?(user)
      user.artifacts.where(approved: true).count >= Artifact.approved_count_for_trust
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
      search_params.each do |param_name, _|
        if params[param_name].present?
          params[param_name] = params[param_name].gsub('%20',' ').gsub('%2C', ',')
        end
      end
    end
end
