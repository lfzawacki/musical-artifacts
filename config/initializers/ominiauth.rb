# Enable omniauth providers by putting them on this list
# and adding 'provider_key' and 'provider_secret' on config/secrets.yml
Rails.application.config.omniauth_providers = [
    :github,
    :google_oauth2,
    :soundcloud,
    :twitter,
    :linuxfr
]

Rails.application.config.middleware.use OmniAuth::Builder do

  Rails.application.config.omniauth_providers.each do |p|
    provider p, Rails.application.secrets["#{p}_key"], Rails.application.secrets["#{p}_secret"], image_size: 'bigger', secure_image_url: true
  end
end
