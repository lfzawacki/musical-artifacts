require "test_helper"

class FavoritesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @artifact = FactoryGirl.create(:artifact)
    @user = User.create email: 'freddie@que.en', password: 'dontstophim'
  end

  test "can't favorite if it's not logged in" do

    assert_difference('Favorite.count', 0) do
      post :create, artifact_id: @artifact.id
    end

    assert_redirected_to new_user_session_path
  end

  test "can't unfavorite if it's not logged in" do

    assert_difference('Favorite.count', 0) do
      delete :destroy, artifact_id: @artifact.id
    end

    assert_redirected_to new_user_session_path
  end

  test 'favorite an artifact' do
    sign_in(@user)

    assert_difference('Favorite.count', 1) do
      post :create, artifact_id: @artifact.id
    end

    assert_equal @artifact.favorite_count, 1
    assert_equal @user.favorite_artifacts.count, 1
  end

  test 'unfavorite an artifact' do
    sign_in(@user)
    Favorite.create user: @user, artifact: @artifact

    assert_difference('@user.favorite_artifacts.count', -1) do
      delete :destroy, artifact_id: @artifact.id
    end

    assert_equal @artifact.favorite_count, 0
    assert_equal @user.favorite_artifacts.count, 0
  end

  test "can't unfavorite if artifact not favorited" do
    sign_in(@user)

    assert_difference('@user.favorite_artifacts.count', 0) do
      delete :destroy, artifact_id: @artifact.id
    end
  end

  test "can't favorite if artifact is already favorited" do
    sign_in(@user)
    Favorite.create user: @user, artifact: @artifact

    assert_difference('Favorite.count', 0) do
      post :create, artifact_id: @artifact.id
    end
  end

  test 'create and destroy favorites for a user' do
    sign_in(@user)

    artifact2 = FactoryGirl.create(:artifact)
    artifact3 = FactoryGirl.create(:artifact)

    post :create, artifact_id: @artifact.id
    post :create, artifact_id: artifact2.id
    post :create, artifact_id: artifact3.id

    assert_equal @artifact.favorite_count, 1
    assert_equal artifact2.favorite_count, 1
    assert_equal artifact3.favorite_count, 1

    assert_equal @user.favorite_artifacts.count, 3

    delete :destroy, artifact_id: artifact3.id

    assert_equal artifact3.favorite_count, 0

    assert_equal @user.favorite_artifacts.count, 2
  end

  test 'create and destroy favorites for an artifact' do
    sign_in(@user)

    user2 = FactoryGirl.create(:user)
    user3 = FactoryGirl.create(:user)

    post :create, artifact_id: @artifact.id

    sign_out :user
    sign_in(user2)

    post :create, artifact_id: @artifact.id

    sign_out :user
    sign_in(user3)

    post :create, artifact_id: @artifact.id

    assert_equal @artifact.favorite_count, 3

    assert_equal @user.favorite_artifacts.count, 1
    assert_equal user2.favorite_artifacts.count, 1
    assert_equal user3.favorite_artifacts.count, 1
  end

  #
  # -- JSON API tests
  #
  test 'create a favorite' do
  end

  test 'destroy a favorite' do
  end
end
