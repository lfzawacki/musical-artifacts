class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # Normal form authentication
  protect_from_forgery with: :exception, unless: :is_api_call?

  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  # API specific authentication
  before_action :api_authenticate

  before_filter :load_settings
  before_filter :count_unapproved_artifacts

  # When a controller gets the user via current_user
  def load_user
    @user = current_user
  end

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
  # Extracted from the Knock::Authenticatable module because it interfered with devise
  # https://github.com/nsarno/knock/blob/master/lib/knock/authenticable.rb#L4
  def api_authenticate
    if current_user.blank? && request.headers['Authorization'].present?
      token = request.headers['Authorization'].split(' ').last
      @current_user = Knock::AuthToken.new(token: token).current_user
    end
  end

  # Test for write calls which are JSON, so that we authenticate
  # with JWT using it instead of  Devise via HTTP
  def is_api_call?
    ['POST', 'PUT'].include?(request.method) && request.format == 'application/json'
  end

  def load_settings
    @setting = Setting.first
  end

  def count_unapproved_artifacts
    @unapproved_artifacts = Artifact.where(approved: false).count
  end

end
