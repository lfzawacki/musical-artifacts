class ArtifactsController < InheritedResources::Base
  before_filter :search_artifacts, only: [:index]
  before_filter :set_software, only: [:index]

  authorize_resource

  respond_to :json

  def download
    @artifact = Artifact.find(params[:id])

    file = @artifact.get_file_by_name("#{params[:filename]}.#{params[:format]}")
    if file.present?
      send_file Pathname(file.path).realdirpath
    else
      render :file => "#{Rails.root}/public/404.html",  :status => 404
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
      @artifacts = Artifact.all

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

end
