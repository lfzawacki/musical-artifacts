require "test_helper"

class ArtifactSearchesTest < Capybara::Rails::TestCase

  setup do
    @setting = Setting.first

    @artifact = FactoryGirl.create(:artifact)

    @admin = FactoryGirl.create(:user, email: 'bruce@maiden.ir', password: 'emperoroftheclouds', admin: true)
    @user = FactoryGirl.create(:user, email: 'janick@maiden.ir', password: 'writerofsouls')
  end

  # Mostly tests if pages render properly with these kinds of searches
  # that would break it because of duplicated tags
  test 'searches for multiple tags should not error (tags, formats)' do
    visit artifacts_path(tags: 'sfz', formats: 'sfz')

    assert_content page, @setting.site_name
  end

  test 'searches for multiple tags should not error (tags, apps, formats)' do
    visit artifacts_path(tags: 'guitarix', formats: 'guitarix', apps: 'guitarix')

    assert_content page, @setting.site_name
  end

  test 'searches for multiple tags should not error (tags and normal search)' do
    visit artifacts_path(tags: 'wubalubadub', q: 'wubalubadub')

    assert_content page, @setting.site_name
  end

  test 'searches for multiple tags should not error (tags, apps, formats and normal search)' do
    visit artifacts_path(tags: 'ni', apps: 'ni', formats: 'ni', q: 'ni')

    assert_content page, @setting.site_name
  end

end
