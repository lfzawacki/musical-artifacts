require "test_helper"

class ShowInfoTest < Capybara::Rails::TestCase
  setup do
    @setting = settings(:default)
  end

  test "show about link on main page" do
    visit '/'

    assert_link page, I18n.t('_other.about'), info_about_path
  end

  test "show contact link on main page" do
    visit '/'

    assert_link page, I18n.t('_other.contact'), info_contact_path
  end

  test "show simple information" do
    visit info_about_path

    assert_content page, @setting.site_name
  end
end
