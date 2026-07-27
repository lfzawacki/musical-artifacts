if ENV['CI']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'minitest/rails/capybara'
require 'faker'

Fog.mock!

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     'test',
    aws_secret_access_key: 'test',
    region:                'us-east-1',
  }
  config.fog_directory  = 'musical-artifacts-test'
  config.fog_public     = true
  config.storage        = :fog
end

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(color: true)

Rails.logger.level = Logger::WARN if Rails.logger

# To get mock emails in test environment
ActionMailer::Base.default_url_options = { host: 'https://musical-artifacts.com' }

class ActiveSupport::TestCase

  self.use_transactional_fixtures = true

  setup do
    I18n.locale = :en
    Fog::Mock.reset
    connection = Fog::Storage.new(
      provider:              'AWS',
      aws_access_key_id:     'test',
      aws_secret_access_key: 'test',
      region:                'us-east-1',
    )
    connection.directories.create(key: 'musical-artifacts-test')
  end

  teardown do
    Capybara.reset_sessions!
    Rails.cache.clear
  end

  # To open files
  def fixture_file file
    File.open(File.join(Rails.root, '/test/fixtures/files', file))
  end

  # For features
  def show_page
    save_page Rails.root.join( 'public', 'capybara.html' )
    %x(launchy http://localhost:6666/capybara.html)
  end

  def login_with user, password
    visit new_user_session_path
    assert page.has_field?('user_email'), "Expected login form to be visible at #{current_path}, got: #{page.status_code}"
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: password
    click_button I18n.t('_other.login')
  end

  def api_authenticate user
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    request.env['HTTP_AUTHORIZATION'] = "bearer #{token}"
  end

  def json_body
    JSON.parse(response.body)
  end

  def with_storage(type, &block)
    ArtifactFileUploader.storage(type)
    yield
  ensure
    ArtifactFileUploader.storage(:fog)
    CarrierWave::Uploader::Base.fog_credentials = { provider: 'AWS', aws_access_key_id: 'test', aws_secret_access_key: 'test', region: 'us-east-1' }
    CarrierWave::Uploader::Base.fog_directory = 'musical-artifacts-test'
    CarrierWave::Uploader::Base.fog_public = true
    FileUtils.rm_rf(Dir[Rails.root.join('public', 'uploads')])
    Fog::Mock.reset
    connection = Fog::Storage.new(provider: 'AWS', aws_access_key_id: 'test', aws_secret_access_key: 'test', region: 'us-east-1')
    connection.directories.create(key: 'musical-artifacts-test')
  end
end
