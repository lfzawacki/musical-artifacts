require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = FactoryBot.build(:user)
  end

  test "validates email" do
    @user.email = nil
    refute @user.valid?
    assert_includes @user.errors[:email], "can't be blank"

    @user.email = "invalid_email"
    refute @user.valid?
    assert_includes @user.errors[:email], "is invalid"
  end

  test "validates username" do
    @user.username = nil
    refute @user.valid?
    assert_includes @user.errors[:username], "can't be blank"
  end

  test "create_activity" do
    skip
  end

  test "favorite_artifacts" do
    user = FactoryBot.create(:user)
    artifact = FactoryBot.create(:artifact)

    assert_empty user.favorite_artifacts

    Favorite.create(user: user, artifact: artifact)

    assert_includes user.reload.favorite_artifacts, artifact
  end

end
