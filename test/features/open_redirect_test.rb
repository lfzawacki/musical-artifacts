require 'test_helper'

class OpenRedirectTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  setup do
    @user = FactoryBot.create(:user,
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'password123',
    )
  end

  test "safe redirects work as expected" do
    # 1. User visits a safe, valid path
    visit licenses_path

    # 2. User goes to login page
    visit new_user_session_path

    # 3. User logs in
    fill_in User.human_attribute_name(:email), with: @user.email
    fill_in User.human_attribute_name(:password), with: 'password123'
    find('input[type="submit"]').click

    # 4. User is correctly redirected back to the safe path
    assert_equal licenses_path, page.current_path
  end

  test "open redirect attempts are blocked and fallback to default path" do
    # We simulate the user attempting to visit a malicious path.
    # The Rails router usually blocks this with a 404 RoutingError, but we test
    # the workflow to ensure that even if they try, it defaults correctly upon login.
    begin
      visit '//malicious.com'
    rescue ActionController::RoutingError
      # Expected behavior
    end

    visit new_user_session_path

    # Log in
    fill_in User.human_attribute_name(:email), with: @user.email
    fill_in User.human_attribute_name(:password), with: 'password123'
    find('input[type="submit"]').click

    # User MUST NOT be at malicious.com. They should fall back to the safe artifacts_path.
    assert_not_equal 'http://malicious.com/', page.current_url
    assert_equal artifacts_path, page.current_path
  end

  test "encoded slash open redirect attempts fall back to default path" do
    # Attackers sometimes use URI encoded slashes to bypass basic router filters
    # e.g., /%2Fmalicious.com. We want to ensure safe_redirect_path? catches it.
    begin
      visit '/%2Fmalicious.com'
    rescue ActionController::RoutingError
      # Expected behavior
    end

    visit new_user_session_path

    fill_in User.human_attribute_name(:email), with: @user.email
    fill_in User.human_attribute_name(:password), with: 'password123'
    find('input[type="submit"]').click

    # Ensure the encoded bypass didn't succeed
    assert_not_includes page.current_url, 'malicious.com'
    assert_equal artifacts_path, page.current_path
  end
end
