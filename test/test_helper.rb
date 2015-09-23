require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'minitest/rails/capybara'
require 'html_reporter'
require 'forgery'

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Reporters::HtmlReporter.new]

class ActiveSupport::TestCase

  self.use_transactional_fixtures = true

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
end
