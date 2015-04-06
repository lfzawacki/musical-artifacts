class ArtifactsController < InheritedResources::Base

  private

    def artifact_params
      params.require(:artifact).permit(
        :name, :description, :author, :file, :license_id, :software_list, :tag_list, :file_hash, :mirrors
      )
    end

end
