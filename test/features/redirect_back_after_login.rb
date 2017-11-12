require "test_helper"

class RedirectBackAfterLogin < Capybara::Rails::TestCase

  setup do
    @setting = Setting.first
    @artifact = FactoryBot.create(:artifact)
    @user = FactoryBot.create(:user, email: 'gene@strapping.yl', password: 'farbeyondmetal')
  end

  test "redirect to an artifact page" do
    visit artifact_path(@artifact)

    assert_equal current_path, artifact_path(@artifact)

    login_with(@user, 'farbeyondmetal')

    assert_equal current_path, artifact_path(@artifact)
  end

  test "redirect back to login screen after failed attempt" do
    visit artifact_path(@artifact)

    assert_equal current_path, artifact_path(@artifact)

    login_with(@user, 'antiproduct') # invalid password

    assert_equal current_path, new_user_session_path
  end

  test "redirect to artifacts index with parameters" do
    path = artifacts_path(tags: 'some_tags')

    visit path

    uri = URI.parse(current_url)

    assert_equal "#{uri.path}?#{uri.query}", path

    login_with(@user, 'farbeyondmetal')

    assert_equal "#{uri.path}?#{uri.query}", path
  end

  test "redirect back to my artifacts page after login" do
    visit my_artifacts_path

    assert_equal current_path, new_user_session_path

    login_with(@user, 'farbeyondmetal')

    assert_equal current_path, my_artifacts_path
  end

  test "redirect back to new artifact page after login" do
    visit new_artifact_path

    assert_equal current_path, new_user_session_path

    login_with(@user, 'farbeyondmetal')

    assert_equal current_path, new_artifact_path
  end

  test "redirect back to new artifact page after registering" do
    visit new_artifact_path

    assert_equal current_path, new_user_session_path

    click_link I18n.t('_other.signup')

    fill_in 'user_email', with: 'jed@strapping.yl'
    fill_in 'user_password', with: 'wrongside'
    fill_in 'user_password_confirmation', with: 'wrongside'

    click_button I18n.t('_other.signup')

    assert_equal current_path, new_artifact_path
  end

  test "redirect to artifacts path after logout" do
    login_with(@user, 'farbeyondmetal')

    visit my_artifacts_path

    click_button I18n.t('_other.logout')

    assert_equal current_path, artifacts_path
  end
end
