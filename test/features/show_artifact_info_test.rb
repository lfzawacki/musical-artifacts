require "test_helper"

class ShowArtifactInfoTest < Capybara::Rails::TestCase

  setup do
    @setting = Setting.first
    @artifact = FactoryGirl.create(:artifact)
    @admin = FactoryGirl.create(:user, email: 'peter@genes.is', password: 'watcheroftheskies', admin: true)
    @user = FactoryGirl.create(:user, email: 'phil@genes.is', password: 'musicalbox')
  end

  test "show artifact simple data" do
    visit artifact_path(@artifact)

    assert_content page, @artifact.name
    assert_content page, @artifact.description
    assert_content page, @artifact.author
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
    login_with(@user, 'watcheroftheskies')
    visit artifact_path(@artifact)

    assert_no_link I18n.t('_other.edit')
    assert_no_link I18n.t('_other.destroy')
  end

  test "see download button if file is present" do
    @artifact.update_attributes(file: fixture_file('example.gx'))

    visit artifact_path(@artifact)
    assert_link I18n.t('artifacts.buttons.download')
  end

end
