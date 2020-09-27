require "test_helper"

class ShowInfoTest < Capybara::Rails::TestCase
  setup do
    @setting = Setting.first
    @admin = FactoryBot.create(:user, email: 'gnome@dio.io', password: 'sunsetsuperman', admin: true)
    @user = FactoryBot.create(:user, email: 'vinnie@dio.io', password: 'holydiver')
  end

  test "show user name and salutation when logged in (admin)" do
    login_with(@admin, 'sunsetsuperman')
    visit '/'

    assert_link page, I18n.t('layouts.application.current_user', user: @admin.username), href: my_artifacts_path
  end

  test "show user name and salutation when logged in (user)" do
    login_with(@user, 'holydiver')
    visit '/'

    assert_link page, I18n.t('layouts.application.current_user', user: @user.username), href: my_artifacts_path
  end

  test "show user email and salutation when logged in (user) and has no name set" do
    login_with(@admin, 'sunsetsuperman')

    # some old users dont have a username in the DB, so setting it here
    # with update_column to bypass DB validations
    @admin.update_column :username, nil

    visit '/'

    assert_link page, I18n.t('layouts.application.current_user', user: @admin.email), href: my_artifacts_path
  end

  test "show about link on main page" do
    visit '/'

    assert_link page, I18n.t('_other.about'), href: info_about_path
  end

  test "show contact link on main page" do
    visit '/'

    assert_link page, I18n.t('_other.contact'), href: info_contact_path
  end

  test "show settings link on main page for logged in admin" do
    login_with @admin, 'sunsetsuperman'
    visit '/'

    assert_link page, I18n.t('layouts.application.settings'), href: settings_path
  end

  test "show admin link on main page for logged in admin" do
    login_with @admin, 'sunsetsuperman'
    visit '/'

    assert_link page, I18n.t('layouts.application.admin'), href: admin_root_path
  end

  test "show number of unapproved artifacts for admin" do
    login_with @admin, 'sunsetsuperman'

    FactoryBot.create(:artifact, approved: false)
    FactoryBot.create(:artifact, approved: false)

    visit '/'

    assert_link page, '2', href: admin_root_path
  end

  test "don't show number of unapproved artifacts for normal user" do
    login_with @user, 'holydiver'

    FactoryBot.create(:artifact, approved: false)

    visit '/'

    assert_no_link page, admin_root_path, '1'
  end

  test "show number of artifacts for an admin (2, 1 for other user)" do
    login_with @admin, 'sunsetsuperman'

    FactoryBot.create(:artifact, user: @user)
    FactoryBot.create(:artifact, user: @admin)
    FactoryBot.create(:artifact, user: @admin)

    visit '/'

    assert_link page, '2', href: my_artifacts_path
  end

  test "show number of artifacts for a user (none)" do
    login_with @user, 'holydiver'

    visit '/'

    assert_link page, '0', href: my_artifacts_path
  end

  test "show number of artifacts for a user (3, 1 for other user)" do
    login_with @user, 'holydiver'

    FactoryBot.create(:artifact, user: @user)
    FactoryBot.create(:artifact, user: @user)
    FactoryBot.create(:artifact, user: @user)
    FactoryBot.create(:artifact, user: @admin)

    visit '/'

    assert_link page, '3', href: my_artifacts_path
  end

  test "show logout link for normal user" do
    login_with @user, 'holydiver'
    visit '/'

    assert_link page, I18n.t('_other.logout'), href: destroy_user_session_path()
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
