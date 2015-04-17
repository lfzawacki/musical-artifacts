class ArtifactsController < InheritedResources::Base
  before_filter :search_artifacts, only: [:index]

  respond_to :json

  def index
    index! do |format|
      format.html { render(partial: 'artifact_list', layout: false) if request.xhr? }
    end
  end

  private

    def artifact_params
      params.require(:artifact).permit(
        :name, :description, :author, :file, :license_id, :software_list, :tag_list, :file_hash, :mirrors
      )
    end

    def search_artifacts
      @artifacts = Searches.artifacts_by_metadata(params[:q])
    end

end
