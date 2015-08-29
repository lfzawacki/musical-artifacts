require "test_helper"

class ShowInfoTest < Capybara::Rails::TestCase
  setup do
    @setting = Setting.first
    @admin = FactoryGirl.create(:user, email: 'gnome@dio.io', password: 'sunsetsuperman', admin: true)
    @user = FactoryGirl.create(:user, email: 'vinnie@dio.io', password: 'holydiver')
  end

  test "show about link on main page" do
    visit '/'

    assert_link page, I18n.t('_other.about'), info_about_path
  end

  test "show contact link on main page" do
    visit '/'

    assert_link page, I18n.t('_other.contact'), info_contact_path
  end

  test "show settings link on main page for logged in admin" do
    login_with @admin, 'sunsetsuperman'
    visit '/'

    assert_link page, I18n.t('layouts.application.settings'), settings_path
  end

  test "show admin link on main page for logged in admin" do
    login_with @admin, 'sunsetsuperman'
    visit '/'

    assert_link page, I18n.t('layouts.application.admin'), admin_root_path
  end

  test "show number of unapproved artifacts for admin" do
    login_with @admin, 'sunsetsuperman'

    FactoryGirl.create(:artifact, approved: false)
    FactoryGirl.create(:artifact, approved: false)

    visit '/'

    assert_link page, '2', admin_root_path
  end

  test "don't show number of unapproved artifacts for normal user" do
    login_with @user, 'holydiver'

    FactoryGirl.create(:artifact, approved: false)

    visit '/'

    assert_no_link page, admin_root_path, '1'
  end

  test "show logout link for normal user" do
    login_with @user, 'holydiver'
    visit '/'

    assert_link page, I18n.t('_other.logout'), destroy_user_session_path()
  end

  test "links a normal user shouldn't see" do
    login_with @user, 'holydiver'
    visit '/'

    assert_no_link page, I18n.t('layouts.application.settings'), settings_path
    assert_no_link page, I18n.t('layouts.application.admin'), admin_root_path
    assert_no_link page, I18n.t('_other.login'), new_user_session_path
    assert_no_link page, I18n.t('_other.signup'), new_user_registration_path
  end

  test "links a logged out user shouln't see" do
    visit '/'

    assert_no_link page, I18n.t('layouts.application.settings'), settings_path
    assert_no_link page, I18n.t('layouts.application.admin'), admin_root_path
    assert_no_link page, I18n.t('_other.logout'), new_user_session_path
  end

  test "show simple information" do
    visit info_about_path

    assert_content page, @setting.site_name
  end
end
