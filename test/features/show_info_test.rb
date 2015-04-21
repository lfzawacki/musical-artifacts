require "test_helper"

class ShowInfoTest < Capybara::Rails::TestCase
  setup do
  end

  test "show about link on main page" do
    visit '/'

    assert_content page, link_to('About', info_about_path)
  end

  test "show simple information" do
    visit info_about_path

    assert_content page, 'Musical Artifacts'
  end
end
