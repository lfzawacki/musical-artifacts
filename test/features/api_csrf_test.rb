require 'test_helper'

class ApiCsrfTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  setup do
    # Assuming standard test setups exist, setup a dummy user
    @user = FactoryBot.create(:user,
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'password123',
    )

    # Create a license to pass validation
    @license = License.first
  end

  test "JSON POST with session cookie but no CSRF token fails due to nullified session" do
    # 1. Sign in
    login_with(@user, @user.password)

    # Temporarily enable CSRF protection to test the vulnerability
    ActionController::Base.allow_forgery_protection = true

    begin
      # 2. Simulate CSRF attack: POST to a JSON endpoint using the session cookie, but NO CSRF token
      # We use page.driver (Rack::Test) to make a raw POST request with the session cookie established above
      page.driver.post artifacts_path(format: :json), {
        artifact: {
          name: 'Malicious Artifact',
          description: 'Attack',
          author: 'Attacker',
          license_id: @license.id
        }
      }

      # 3. Expect failure: The null_session strategy clears the session during this request.
      # Because `current_user` evaluates to nil, CanCanCan should deny access resulting in unauthorized (401)
      assert_equal 401, page.driver.status_code
    ensure
      # Turn it back off so we don't break other tests
      ActionController::Base.allow_forgery_protection = false
    end
  end

  test "JSON POST with valid JWT token succeeds" do
    # 1. Generate a valid Knock JWT token for the user
    token = Knock::AuthToken.new(payload: { sub: @user.id }).token

    ActionController::Base.allow_forgery_protection = true

    begin
      # 2. Perform POST to JSON endpoint with the Authorization header using Capybara's driver
      page.driver.header 'Authorization', "Bearer #{token}"
      page.driver.header 'Content-Type', 'application/json'
      page.driver.header 'Accept', 'application/json'

      page.driver.post artifacts_path(format: :json), {
        artifact: {
          name: 'Legit API Artifact',
          description: 'Valid',
          author: 'API User',
          license_id: @license.id
        }
      }.to_json

      # 3. Expect success as the api_authenticate method verifies the token (200 OK)
      assert_equal 200, page.driver.status_code
    ensure
      ActionController::Base.allow_forgery_protection = false
    end
  end
end
