class ArtifactsController < InheritedResources::Base
  before_filter :search_artifacts, only: [:index]
  before_filter :set_software, only: [:index]

  respond_to :json

  def index
    index! do |format|
      format.html { render(partial: 'artifact_list', layout: false) if request.xhr? }
    end
  end

  private

    def artifact_params
      params.require(:artifact).permit(
        :name, :description, :author, :file, :license_id, :more_info_urls, :software_list, :tag_list, :file_hash, :mirrors
      )
    end

    def search_artifacts
      @artifacts = Artifact.all

      # searches by tags, apps, licenses
      @artifacts = Searches.artifacts_tagged_with(@artifacts, params[:tags])
      @artifacts = Searches.artifacts_app_tagged_with(@artifacts, params[:apps])
      @artifacts = Searches.artifacts_licensed_as(@artifacts, params[:licenses])

      @artifacts = Searches.artifacts_by_metadata(@artifacts, params[:q])
    end

    def set_software
      @software = params[:app]
    end

end
