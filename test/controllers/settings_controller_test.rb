require "test_helper"

class SettingsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @setting = Setting.first
    @user = FactoryBot.create :user, email: 'devin@hevydevy.ca', password: 'deadhead'
    @admin = FactoryBot.create :user, email: 'ziltoid@ziltoida.ca', password: 'fetidcoffee', admin: true
  end

  test "admin can edit setting" do
    sign_in(@admin)

    get :edit
    assert_response :success
  end


  test "normal user can't edit setting" do
    sign_in(@user)

    get :edit
    assert_redirected_to root_path
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

  test "admin can update settings" do
    sign_in(@admin)

    patch :update, id: @setting, setting: { site_name: 'Poopy Poop Site' }

    assert_redirected_to settings_path
    assert_not_nil flash[:notice]
  end

  test "normal user can't update settings" do
    sign_in(@user)

    patch :update, id: @setting, setting: { site_name: 'Ocean Machine' }

    assert_redirected_to root_path
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

end
