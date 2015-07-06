class SettingsController < InheritedResources::Base
  before_filter only: [:edit, :update] do
    @setting = Setting.first
  end

  def update
    update! { settings_path }
  end

  def setting_params
      params.require(:setting).permit(Setting.data_attributes)
  end
end
