require "test_helper"

class ArtifactSearchesTest < Capybara::Rails::TestCase

  setup do
    @setting = Setting.first

    @artifact = FactoryBot.create(:artifact)

    @admin = FactoryBot.create(:user, email: 'bruce@maiden.ir', password: 'emperoroftheclouds', admin: true)
    @user = FactoryBot.create(:user, email: 'janick@maiden.ir', password: 'writerofsouls')
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

  test 'normal searches are case insensitive' do
    FactoryBot.create(:artifact, name: 'MiXedCaSeNaMe')
    visit artifacts_path(q: 'mixedcasename')

    assert_content page, 'MiXedCaSeNaMe'
  end

  test 'searches by tags are case insensitive' do
    FactoryBot.create(:artifact, name: 'Taggy artifact', tag_list: ['UPPERcaseTAG'])
    visit artifacts_path(tags: 'uppercasetag')

    assert_content page, 'Taggy artifact'
  end

  test 'searches by apps are case insensitive' do
    FactoryBot.create(:artifact, name: 'Appy artifact', software_list: ['SOMEApp'])
    visit artifacts_path(apps: 'someapp')

    assert_content page, 'Appy artifact'
  end

  test 'searches by formats are case insensitive' do
    FactoryBot.create(:artifact, name: 'Formatty artifact', file_format_list: ['WavEForm'])
    visit artifacts_path(formats: 'waveform')

    assert_content page, 'Formatty artifact'
  end

  test 'search with only free licenses' do
    skip
  end

  test 'empty search has a link back to the home page' do
    skip
  end

  test 'search with no tags for a category dont have a sidebar for it (tags)' do
    skip
  end

  test 'search with no tags for a category dont have a sidebar for it (app tags)' do
    skip
  end

  test 'search with no tags for a category dont have a sidebar for it (file formats)' do
    skip
  end

end
