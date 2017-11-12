require "test_helper"

class ShowArtifactInfoTest < Capybara::Rails::TestCase

  setup do
    @artifact = FactoryBot.create(:artifact)
    @admin = FactoryBot.create(:user, email: 'peter@genes.is', password: 'watcheroftheskies', admin: true)
    @user = FactoryBot.create(:user, email: 'phil@genes.is', password: 'musicalbox')
  end

  test "show artifact simple data" do
    visit artifact_path(@artifact)

    assert_content page, @artifact.name
    assert_content page, @artifact.description
    assert_content page, @artifact.author
  end

  test "see uploaded date next to author name" do
    skip
  end

  test "see updated date next to uploaded date when different" do
    skip
  end

  test "see (no description) on artifact with no description" do
    skip
  end

  test "see buttons if an admin is logged in" do
    login_with(@admin, 'watcheroftheskies')
    visit artifact_path(@artifact)

    assert_link I18n.t('_other.edit'), edit_artifact_path(@artifact)
    assert_link I18n.t('_other.destroy'), artifact_path(@artifact)
  end

  test "see edit button if a normal user the creator of the artifact" do
    @artifact.update_attributes(user: @user)
    login_with(@user, 'musicalbox')

    visit artifact_path(@artifact)

    assert_link I18n.t('_other.edit')
    assert_no_link I18n.t('_other.destroy')
  end

  test "see no buttons if a normal user is logged in" do
    login_with(@user, 'musicalbox')
    visit artifact_path(@artifact)

    assert_no_link I18n.t('_other.edit')
    assert_no_link I18n.t('_other.destroy')
  end

  test "see warning if artifact is unapproved" do
    login_with(@user, 'musicalbox')

    @artifact.update_attributes(user: @user, approved: false, file: fixture_file('example.gx'))

    visit artifact_path(@artifact)
    assert_content page, I18n.t('artifacts.show.unapproved')
    assert_link I18n.t('artifacts.side_buttons.download')
  end

  test "see wayback switch link if there's more info urls" do
    @artifact.update_attributes(mirrors: [], more_info_urls: 'https://eltonjo.hn')

    visit artifact_path(@artifact)
    assert_link I18n.t('artifacts.wayback_links.broken')
  end

  test "see wayback switch link if there's mirrors" do
    @artifact.update_attributes(mirrors: ['https//ghost.bc'], more_info_urls: [])

    visit artifact_path(@artifact)
    assert_link I18n.t('artifacts.wayback_links.broken')
  end

  test "don't see wayback switch link if there's no mirrors nor more_info_urls" do
    @artifact.update_attributes(mirrors: [], more_info_urls: [])

    visit artifact_path(@artifact)
    assert_no_link I18n.t('artifacts.wayback_links.broken')
  end

  test "see download button if file is present" do
    @artifact.update_attributes(file: fixture_file('example.gx'))

    visit artifact_path(@artifact)
    assert_link I18n.t('artifacts.side_buttons.download')
  end

  test "see download button for mirror if no file is present" do
    @artifact.update_attributes(mirrors: 'https://download.from.here')

    visit artifact_path(@artifact)

    assert_link I18n.t('artifacts.side_buttons.download_mirror') + ' download.from.here'
  end

  test "see download button for mirror if a file is present, but downloadable=false" do
    @artifact.update_attributes(mirrors: 'https://download.from.here', downloadable: false)

    visit artifact_path(@artifact)

    assert_link I18n.t('artifacts.side_buttons.download_mirror') + ' download.from.here'
  end

  test "see download button only for first mirror if no file is present" do
    @artifact.update_attributes(mirrors: 'https://hey.here, http://not.from.here')

    visit artifact_path(@artifact)

    assert_link I18n.t('artifacts.side_buttons.download_mirror') + ' hey.here'
  end

  test "don't break application if first mirror link is an invalid URL" do
    @artifact.update_attributes(mirrors: 'I am an invalid URL, http://not.from.here')

    visit artifact_path(@artifact)

    assert_link I18n.t('artifacts.side_buttons.download_mirror')
  end

  test "see download button, but not for mirror if file is present" do
    @artifact.update_attributes(file: fixture_file('example.gx'), mirrors: 'https://validmirror.com')

    visit artifact_path(@artifact)
    assert_link I18n.t('artifacts.side_buttons.download')
    assert_no_link I18n.t('artifacts.side_buttons.download_mirror') + ' validmirror.com'
  end

  test "see favorite icon and number in artifact when logged out" do

    visit artifact_path(@artifact)
    assert_css '.inactive-favorite'
    assert_no_css 'a.favorite'
    assert_no_css 'a.unfavorite'

    within('.favorite-count') do
      assert_content 0
    end
  end

  test "see favorite number for lots of favorites" do
    visit artifact_path(@artifact)
    1.upto(5) do
      Favorite.create artifact: @artifact, user: FactoryBot.create(:user)
    end

    visit artifact_path(@artifact)

    within('.favorite-count') do
      assert_content 5
    end
  end

  test "see favorite icon and favorite link when logged in" do
    login_with(@user, 'musicalbox')

    visit artifact_path(@artifact)

    assert_no_css '.inactive-favorite'
    assert_css '.favorite'
    assert_css '.unfavorite.hidden'

    within('.unfavorite .favorite-count') do
      assert_content 0
    end

    # Now favorite it
    find('.favorite').click

    visit artifact_path(@artifact)
    assert_no_css '.inactive-favorite'
    assert_css '.favorite.hidden'
    assert_css '.unfavorite'

    within('.favorite .favorite-count') do
      assert_content 1
    end

  end

  test "see unfavorite icon and unfavorite link when logged in and favorited" do
    login_with(@user, 'musicalbox')
    Favorite.create artifact: @artifact, user: @user

    visit artifact_path(@artifact)

    assert_no_css '.inactive-favorite'
    assert_css '.favorite.hidden'
    assert_css '.unfavorite'

    within('.favorite .favorite-count') do
      assert_content 1
    end

    # Now unfavorite it
    find('.unfavorite').click

    visit artifact_path(@artifact)
    assert_no_css '.inactive-favorite'
    assert_css '.favorite'
    assert_css '.unfavorite.hidden'

    within('.unfavorite .favorite-count') do
      assert_content 0
    end

  end

  test "see download count on the icon" do
    @artifact.update_attributes(file: fixture_file('example.gx'))

    # With no downloads
    visit artifact_path(@artifact)

    within('.download-count') do
      assert_content 0
    end

    # After a download
    find('a.btn-download').click
    visit artifact_path(@artifact)

    within('.download-count') do
      assert_content 1
    end

    # With an arbitrary value
    @artifact.update_attributes(download_count: 10)
    visit artifact_path(@artifact)

    within('.download-count') do
      assert_content 10
    end
  end

  test "see file content list for zip files" do
    @artifact.update_attributes(file: fixture_file('under.zip'))

    visit artifact_path(@artifact)

    assert_content I18n.t('artifacts.file_listing.title')
  end

  test "see more info url for audio files" do
    ['mp3', 'wav', 'ogg', 'flac'].each do |audio_format|
      @artifact.update_attributes(more_info_urls: ["https://audiofiles.xyz/audio.#{audio_format}"])

      visit artifact_path(@artifact)

      assert_content I18n.t('artifacts.more_info_multimedia.title')
    end
  end

  test "see more info url for youtube" do
    @artifact.update_attributes(more_info_urls: ["https://www.youtube.com/watch?v=vidyos"])

    visit artifact_path(@artifact)

    assert_content I18n.t('artifacts.more_info_multimedia.title')
  end

  test "see more info url for images" do
    ['jpg', 'jpeg', 'png', 'gif'].each do |img_format|
      @artifact.update_attributes(more_info_urls: ["https://imgdump.net/img.#{img_format}"])

      visit artifact_path(@artifact)

      assert_content I18n.t('artifacts.more_info_multimedia.title')
    end
  end

  test "see more info url for soundcloud" do
    @artifact.update_attributes(more_info_urls: ["https://soundcloud.com/somesongs/arecool"])

    visit artifact_path(@artifact)

    assert_content I18n.t('artifacts.more_info_multimedia.title')
  end

  test "see email filter on description" do
    skip
  end

  # Test each license more thoroughly (for now just want to know if the page is breaking or not)
  License.all.each do |license|
    test "show an artifact licensed as #{license.short_name}" do
      @artifact.update_attributes(license: license, name: "#{license.short_name} artifact")

      visit artifact_path(@artifact)

      assert_css '.license'
    end

    test "index with an artifact licensed as #{license.short_name}" do
      @artifact.update_attributes(license: license, name: "#{license.short_name} artifact")

      visit artifacts_path

      assert_css '.license'
      assert_link '', artifacts_path(license: license.short_name)
    end

  end

  test "see #back-button when coming from an internal referrer" do
    skip
  end

  test "don't see #back-button when coming from an external referrer" do
    skip
  end

  test "don't see #back-button when no referrer is present" do
    skip
  end

end
