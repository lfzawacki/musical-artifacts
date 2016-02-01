class Users::AuthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :trust_provider_email_address

  def google_oauth2
    create_with_omniauth
  end

  def linuxfr
    create_with_omniauth
  end

  def github
    create_with_omniauth
  end

  # Integrations which need extra information
  # (because they dont send the email parameter)
  def soundcloud
    create_without_email
  end

  def twitter
    create_without_email
  end

  # Is called right away when integrations send all the data (e.g. github, google)
  # Is called after 'create_without_email' when we need to get the email before completing
  def create_with_omniauth
    # Get the email from the form if it's present
    # We won't link accounts this way
    if params[:user] && params[:user][:email]
      session[:omniauth_cache]['info']['email'] = params[:user][:email]
    end

    # Use omniauth data or cached data, depending on which kind of call this is
    data = request.env["omniauth.auth"] || session[:omniauth_cache]

    @user = @user || User.from_omniauth(data, @find_by_email)

    if @user.errors.empty?
      sign_in_and_redirect @user
    else
      alert = @user.errors[:email] ? t('auth_callbacks.email_error') : t('auth_callbacks.unknown_error', provider: data.provider)
      redirect_to new_user_session_path
    end
  end

  private

  # Shows a form to ask for email when an integration doesnt send one
  def create_without_email

    # If there's a user registered with this integration first, just go to
    # the second step with the email we need
    @user = User.find_by_omniauth(request.env['omniauth.auth'])
    if @user.present?
      request.env['omniauth.auth'].info.email = @user.email
      create_with_omniauth
    else

      @user = User.new
      @image = request.env['omniauth.auth'].info.image
      @username = request.env['omniauth.auth'].info.nickname || request.env['omniauth.auth'].info.name
      @provider = request.env['omniauth.auth'].provider

      # Cache omniauth info for use after this request
      session[:omniauth_cache] = request.env['omniauth.auth'].slice(:uid, :provider, :info)
      render 'users/_create_without_email'
    end
  end

  def trust_provider_email_address
    # Providers which require authentication before account is usable via oauth
    required = ['linuxfr', 'github']

    data = request.env['omniauth.auth']

    # Denote wether we trust the email and should link it with an already existing account
    @find_by_email = required.include?(action_name) ||
      (data && data['extra']['raw_info']['email_verified'] == 'true') # this is for google_oauth2
  end

end