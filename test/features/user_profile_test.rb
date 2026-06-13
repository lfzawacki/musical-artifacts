require 'test_helper'

class UserProfileTest < Capybara::Rails::TestCase
  setup do
    @user = FactoryBot.create(:user, password: '123456789')
    @other_user = FactoryBot.create(:user, password: '987654321')

    # 3 artifacts owned by @user
    @user_artifact1 = FactoryBot.create(:artifact, name: 'User Artifact 1', user: @user)
    @user_artifact2 = FactoryBot.create(:artifact, name: 'User Artifact 2', user: @user)
    @user_artifact3 = FactoryBot.create(:artifact, name: 'User Artifact 3', user: @user)

    # 2 artifacts owned by another user
    @other_artifact1 = FactoryBot.create(:artifact, name: 'Other Artifact 1', user: @other_user)
    @other_artifact2 = FactoryBot.create(:artifact, name: 'Other Artifact 2', user: @other_user)

    # @user favorites 1 of their own, and 1 from the other user
    Favorite.create!(user: @user, artifact: @user_artifact1)
    Favorite.create!(user: @user, artifact: @other_artifact1)
  end

  test "viewing user profile shows user information and navigation links" do
    login_with(@user, '123456789')

    visit profile_path

    assert_content I18n.t('users.show.user_profile')
    assert_content I18n.t('users.show.user_info')
    assert_content @user.email

    # Check for the presence of the navigation buttons using I18n
    assert_link I18n.t('users.show.your_artifacts'), href: my_artifacts_path
    assert_link I18n.t('users.show.your_favorites'), href: my_favorites_path
  end

  test "viewing user artifacts page shows the correct artifacts and links" do
    login_with(@user, '123456789')

    visit my_artifacts_path

    assert_content I18n.t('users.artifacts.your_artifacts')

    # Check for the navigation links back to profile and to favorites
    assert_link I18n.t('users.artifacts.back_to_profile'), href: profile_path
    assert_link I18n.t('users.artifacts.your_favorites'), href: my_favorites_path

    # Should see only @user's artifacts
    assert_content @user_artifact1.name
    assert_content @user_artifact2.name
    assert_content @user_artifact3.name

    # Should NOT see @other_user's artifacts
    refute_content @other_artifact1.name
    refute_content @other_artifact2.name
  end

  test "viewing user favorites page shows the correct favorited artifacts and links" do
    login_with(@user, '123456789')

    visit my_favorites_path

    assert_content I18n.t('users.favorites.your_favorites')

    # Check for the navigation links back to profile and to artifacts
    assert_link I18n.t('users.favorites.back_to_profile'), href: profile_path
    assert_link I18n.t('users.favorites.your_artifacts'), href: my_artifacts_path

    # Should see the favorited artifacts
    assert_content @user_artifact1.name
    assert_content @other_artifact1.name

    # Should NOT see the unfavorited artifacts
    refute_content @user_artifact2.name
    refute_content @user_artifact3.name
    refute_content @other_artifact2.name
  end
end
