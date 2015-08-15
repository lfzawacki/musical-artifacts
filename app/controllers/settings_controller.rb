class SettingsController < InheritedResources::Base

  authorize_resource
  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  def update
    update! { settings_path }
  end

  def setting_params
      params.require(:setting).permit(Setting.data_attributes)
  end

  private
  def handle_access_denied
    redirect_to root_path, notice: t('_other.access_denied')
  end
end
