class ArtifactsController < InheritedResources::Base
  load_and_authorize_resource

  # For API calls
  respond_to :json

  before_filter only: [:index] do
    load_tag_filters
    search_artifacts
    paginate unless request.format == 'json'
    order_by_params
  end

  def create
    if cannot?(:approve, @artifact)
      @artifact.update_attributes approved: false, user: current_user
      create!(notice: I18n.t('artifacts.create.not_approved'))
    else
      @artifact.update_attributes user: current_user
      create!
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

      file.increment!(:download_count)
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

    def search_artifacts
      remove_duplicated_tags_from_searches # HACKY, read the comments above this method

      @artifacts = Artifact.approved

      # searches by hash, tags, apps, licenses, formats
      @artifacts = Searches.artifacts_with_hash(@artifacts, params[:hash])
      @artifacts = Searches.artifacts_tagged_with(@artifacts, params[:tags])
      @artifacts = Searches.artifacts_app_tagged_with(@artifacts, params[:apps])
      @artifacts = Searches.artifacts_licensed_as(@artifacts, params[:license])
      @artifacts = Searches.artifacts_with_file_format(@artifacts, params[:formats])

      @artifacts = Searches.artifacts_by_metadata(@artifacts, params[:q])
    end

    def paginate
      @artifacts = @artifacts.page(params[:page]).per(20)
    end

    def order_by_params
      order_str = params[:order] || 'created_at'
      direction = params[:asc] ? 'ASC' : 'DESC'

      if ['top_rated', 'name', 'created_at'].include?(order_str)
        order_str = 'favorite_count' if order_str == 'top_rated'

        @artifacts = @artifacts.order("#{order_str} #{direction}")
      else
        @artifacts = @artifacts.order('created_at DESC')
      end
    end

    def load_tag_filters
      @tags = {
        tags: Artifact.tag_counts_on(:tags).where('taggings_count > 1'),
        apps: Artifact.tag_counts_on(:software),
        formats: Artifact.tag_counts_on(:file_formats)
      }
      @licenses = License.license_types - ['copyright']
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
        reversed[params[key]] ||= []
        counts[params[key]] ||= 0

        reversed[params[key]] += [key]
        counts[params[key]] += 1
      end

      # delete repetitions from parameters
      counts.each do |val, count|
        if val != nil
          2.upto(count) do |i|
            Rails.logger.info " *** [PG::DuplicateAlias] deleting duplicated param #{reversed[val][i-1]}"
            params.delete(reversed[val][i-1])
          end
        end
      end
    end

end
