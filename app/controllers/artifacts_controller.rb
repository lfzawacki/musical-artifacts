class ArtifactsController < InheritedResources::Base

  respond_to :json

  private

    def artifact_params
      params.require(:artifact).permit(
        :name, :description, :author, :file, :license_id, :software_list, :tag_list, :file_hash, :mirrors
      )
    end

end
