class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  # Prevent CSRF attacks by raising an exception for HTML requests.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  # Prevent this from being an error 500
  rescue_from ActionController::UnknownFormat, with: :handle_unknown_format

  # API specific authentication
  before_action :api_authenticate, except: [:locale_selector, :comments_script]

  before_filter :load_settings, except: [:locale_selector]
  before_filter :count_unapproved_artifacts, except: [:locale_selector, :comments_script]
  before_filter :set_current_locale

  before_filter :store_location

  before_filter :check_session_for_notifications

  # Fallback access denied handling
  def handle_access_denied exception
    if request.format.json?
      head :unauthorized
    else
      redirect_to root_path, notice: t('_other.access_denied')
    end
  end

  # When a controller gets the user via current_user
  def load_user
    @user = current_user
  end

  # For serving the juvia commenting script in a javascript tag we control
  def comments_script
    render layout: nil
  end

  def locale_selector
    render partial: 'application/locale_selector', layout: false
  end

  protected

  # Use the NullSession strategy explicitly for API calls without overriding global strategy
  def handle_unverified_request
    if is_api_call?
      ActionController::RequestForgeryProtection::ProtectionMethods::NullSession.new(self).handle_unverified_request
    else
      super
    end
  end

  private

  def check_session_for_notifications
    session[:notifications] ||= {}
    session[:notifications]['survey'] ||= DateTime.now
  end

  # Ensures the path is strictly a relative path to prevent Open Redirects
  def safe_redirect_path?(path)
    return false if path.blank? || !path.is_a?(String)
    # Must start with a single slash and not be followed by another slash, backslash, or encoded slash
    path.start_with?('/') && !path.match?(/\A\/+[\/\\]/) && !path.match?(/\A\/+%2f/i)
  end

  def store_location
    paths = ['/users/login', '/users/sign_up', '/users/password/new', '/users/password/edit', '/users/confirmation', '/users/logout']
    auth_paths = /^\/users\/auth\//
    names = ['download']

    if request.method == 'GET' &&
       !paths.include?(request.path) &&
       !auth_paths.match(request.path) &&
       !names.include?(action_name) &&
       !request.xhr? &&
       safe_redirect_path?(request.fullpath)

      session[:previous_path] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    path = session[:previous_path]
    if safe_redirect_path?(path)
      path
    else
      artifacts_path
    end
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
    @setting = Rails.cache.fetch("settings") { Setting.first }
  end

  def count_unapproved_artifacts
    @unapproved_artifacts = Artifact.where(approved: false).count
  end

  def handle_unknown_format(exception)
    msg = "[UnknownFormat] error at #{request.path}"
    logger.error msg

    head :not_acceptable
  end

end
