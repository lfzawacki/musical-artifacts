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

  before_filter :check_session_for_notifications

  # When a controller gets the user via current_user
  def load_user
    @user = current_user
  end

  # For serving the juvia commenting script in a javascript tag we control
  def comments_script
    render layout: nil
  end

  private
  def check_session_for_notifications
    session[:notifications] ||= {}
    session[:notifications]['survey'] ||= DateTime.now
  end

  def store_location
    paths = ['/users/login', '/users/sign_up', '/users/password/new', '/users/password/edit', '/users/confirmation', '/users/logout']
    auth_paths = /^\/users\/auth\//
    names = ['download']
    if request.method == 'GET' &&
       !paths.include?(request.path) &&
       !auth_paths.match(request.path) &&
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

  def extract_locale_from_accept_language_header
    str = request.env['HTTP_ACCEPT_LANGUAGE'] || ''
    str = str.scan(/^[a-z]{2}/).first.to_s

    mapping = {
      'pt' => 'pt-BR'
    }

    locale = mapping[str] || str

    if I18n.available_locales.include?(locale.to_sym)
      locale
    else
      I18n.default_locale
    end
  end

  def get_current_locale
    locale = extract_locale_from_accept_language_header

    locale = session[:locale] if session[:locale].present?

    locale.to_sym
  end

  # Extracted from the Knock::Authenticatable module because it interfered with devise
  # https://github.com/nsarno/knock/blob/master/lib/knock/authenticable.rb#L4
  def api_authenticate

    if current_user.blank? && request.headers['Authorization'].present?
      @current_user ||= begin
        token = request.headers['Authorization'].split.last
        Knock::AuthToken.new(token: token).current_user
      rescue JWT::DecodeError => e
        # recover from specific exceptions
        nil
      end

      head :unauthorized unless current_user
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
