require "test_helper"

class AccessAdminDashboard < Capybara::Rails::TestCase

  setup do
    @admin = FactoryBot.create(:user, email: 'lfz@own.life', password: 'summercomesafter', admin: true)
    @user = FactoryBot.create(:user, email: 'lfz@mortticia.xyz', password: 'oneflower')
  end

  test 'access admin dashboard as an admin' do
    login_with(@admin, 'summercomesafter')

    visit admin_dashboard_path

    assert_equal current_path, admin_dashboard_path
  end

  test 'dont access admin dashboard as a normal user' do
    login_with(@user, 'oneflower')

    visit admin_dashboard_path

    assert_equal current_path, artifacts_path
  end

  test 'dont access admin dashboard as a logged out user' do
    visit admin_dashboard_path

    assert_equal current_path, new_user_session_path
  end
end