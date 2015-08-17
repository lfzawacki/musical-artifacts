class ArtifactsController < InheritedResources::Base
  before_filter :set_software, only: [:index]

  load_and_authorize_resource
  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  before_filter :search_artifacts, only: [:index]

  respond_to :json

  def create
    if cannot?(:approve, @artifact)
      @artifact.update_attributes approved: false
      create!(notice: I18n.t('artifacts.create.not_approved')) { artifacts_path }
    else
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
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end
  end

  private

    def artifact_params
      params.require(:artifact).permit(
        :name, :description, :author, :file, :license_id, :more_info_urls,
        :software_list, :tag_list, :file_hash, :mirrors, :extra_license_text
      )
    end

    def search_artifacts
      @artifacts = Artifact.approved

      # searches by hash, tags, apps, licenses
      @artifacts = Searches.artifacts_with_hash(@artifacts, params[:hash])
      @artifacts = Searches.artifacts_tagged_with(@artifacts, params[:tags])
      @artifacts = Searches.artifacts_app_tagged_with(@artifacts, params[:apps])
      @artifacts = Searches.artifacts_licensed_as(@artifacts, params[:license])

      @artifacts = Searches.artifacts_by_metadata(@artifacts, params[:q])
    end

    def set_software
      @software = params[:app]
    end

    def sanitize_filename_from_params
      # Since users can input the 'filename' just reject dangerous stuff like './' and '../' paths
      filename = params[:filename].clone unless /(?:^|\/)[.]{1,2}(?:\/|$)|^\/.*/.match(params[:filename])
      filename += ".#{params[:format].clone}" if params[:format].present?
      filename
    end

    def handle_access_denied exception
      if [:edit, :update, :download].include?(exception.action)
        redirect_to artifact_path(@artifact), notice: t('_other.access_denied')
      elsif [:new].include?(exception.action)
        redirect_to new_user_session_path
      else
        redirect_to artifacts_path(), notice: t('_other.access_denied')
      end
    end
end
