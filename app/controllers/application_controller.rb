class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  # Prevent CSRF attacks by raising an exception.
  # Normal form authentication
  protect_from_forgery with: :exception, unless: :is_api_call?

  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  # Prevent this from being an error 500 in production
  if Rails.env.production?
    rescue_from ActionController::UnknownFormat, with: :handle_unknown_format
  end

  # API specific authentication
  before_action :api_authenticate

  before_filter :load_settings
  before_filter :count_unapproved_artifacts
  before_filter :set_current_locale

  before_filter :store_location

  # When a controller gets the user via current_user
  def load_user
    @user = current_user
  end

  # For serving the juvia commenting script in a javascript tag we control
  def comments_script
    render layout: nil
  end

  private
  def store_location
    paths = ['/users/login', '/users/sign_up', '/users/password/new', '/users/password/edit', '/users/confirmation', '/users/logout']
    names = ['download']
    if request.method == 'GET' &&
       !paths.include?(request.path) &&
       !names.include?(action_name) &&
       !request.xhr?

      session[:previous_path] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:previous_path] || artifacts_path
  end

  def after_sign_out_path_for(resource_or_scope)
    artifacts_path
  end

  def admin_dashboard_access_denied exception
    redirect_to artifacts_path
  end

  def set_current_locale
    I18n.locale = get_current_locale
  end

  def get_current_locale
    locale = I18n.default_locale

    locale = session[:locale] if session[:locale].present?

    locale.to_sym
  end

  # Extracted from the Knock::Authenticatable module because it interfered with devise
  # https://github.com/nsarno/knock/blob/master/lib/knock/authenticable.rb#L4
  def api_authenticate
    # TODO: Better handling o values present in this header
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

  def handle_unknown_format(exception)
    msg = "[UnknownFormat] error at #{request.path}"
    logger.error msg

    ExceptionNotifier.notify_exception exception, env: request.env, data: {message: msg}

    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end

end
