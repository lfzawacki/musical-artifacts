class AppsController < InheritedResources::Base

  authorize_resource
  private

    def app_params
      params.require(:app).permit(:name, :url, :description)
    end
end

