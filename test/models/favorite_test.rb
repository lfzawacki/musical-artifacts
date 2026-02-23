require "test_helper"

class FavoriteTest < ActiveSupport::TestCase

  setup do
    @artifact = FactoryBot.create(:artifact)
    @user = FactoryBot.create(:user)
    @favorite = Favorite.create artifact: @artifact, user: @user
  end

  test "valid with artifact and user" do
    assert @favorite.valid?
  end

  test "invalid without user" do
    @favorite.user = nil
    refute @favorite.valid?
  end

  test "invalid without artifact" do
    @favorite.artifact = nil
    refute @favorite.valid?
  end

  test "invalid if (user,artifact) is not unique" do
    favorite2 = Favorite.new user: @favorite.user, artifact: @favorite.artifact

    refute favorite2.valid?
  end

  test "get user favorite artifacts" do
    assert_includes @user.favorite_artifacts, @artifact
    assert_equal @user.favorite_artifacts.count, 1
  end

  test "get user favorite artifacts (3 artifacts)" do
    art1 = FactoryBot.create(:artifact)
    art2 = FactoryBot.create(:artifact)
    Favorite.create user: @user, artifact: art1
    Favorite.create user: @user, artifact: art2

    assert_includes @user.favorite_artifacts, @artifact
    assert_includes @user.favorite_artifacts, art1
    assert_includes @user.favorite_artifacts, art2

    assert_equal @user.favorite_artifacts.count, 3
  end

  test "get users who favorited an artifact" do
    user2 = FactoryBot.create(:user)
    Favorite.create(user: user2, artifact: @artifact)

    # Assuming Artifact has a has_many :favorites
    # and has_many :favorited_by_users, through: :favorites, source: :user
    # or similar relation. If not defined in model, we test the join directly.
    favorites = Favorite.where(artifact: @artifact)
    users = favorites.map(&:user)

    assert_includes users, @user
    assert_includes users, user2
  end

  test "create_activity" do
    skip
  end

end
