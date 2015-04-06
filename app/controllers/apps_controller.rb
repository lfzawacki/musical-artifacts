class AppsController < InheritedResources::Base

  private

    def app_params
      params.require(:app).permit(:name, :url, :description)
    end
end

