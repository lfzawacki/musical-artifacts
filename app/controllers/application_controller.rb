class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :load_settings
  before_filter :count_unapproved_artifacts

  # For serving the juvia commenting script in a javascript tag we control
  def comments_script
    render layout: nil
  end

  def admin_dashboard_access_denied exception
    redirect_to artifacts_path
  end

  def after_sign_out_path_for(resource_or_scope)
    artifacts_path
  end

  private
  def load_settings
    @setting = Setting.first
  end

  def count_unapproved_artifacts
    @unapproved_artifacts = Artifact.where(approved: false).count
  end

end
