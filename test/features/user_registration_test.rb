require "test_helper"

class UserRegistration < Capybara::Rails::TestCase

  setup do
  end

  test "visit user creation page" do
    visit new_user_registration_path

    assert_equal current_path, new_user_registration_path
    assert_equal 200, page.status_code
  end

  test "successfully registers a new user" do
    visit new_user_registration_path

    assert_equal current_path, new_user_registration_path

    # Test no users
    assert_equal 0, User.count

    fill_in 'user_username', with: 'somberlain'
    fill_in 'user_email', with: 'david@mortticia.rocks'
    fill_in 'user_password', with: 'netherbound'
    fill_in 'user_password_confirmation', with: 'netherbound'

    click_button I18n.t('_other.signup')

    assert_equal current_path, artifacts_path
    assert_equal 200, page.status_code

    # Test there's a user
    assert_equal 1, User.count
  end

end
