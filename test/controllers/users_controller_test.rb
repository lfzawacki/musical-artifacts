require "test_helper"

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = FactoryGirl.create(:user, email: 'mrwilson@porcupi.ne', password: 'signify trees')
  end

  test "redirect to login if there's no current user" do
    get :show

    assert_redirected_to new_user_session_path
  end

  test 'show my artifacts page for current_user' do
    sign_in(@user)

    get :show

    assert_equal @user, assigns(:user)
    assert_equal Artifact.none, assigns(:artifacts)
  end

  test 'show my artifacts page for current_user (3 artifacts)' do
    sign_in(@user)

    artifacts = [
        FactoryGirl.create(:artifact, user: @user),
        FactoryGirl.create(:artifact, user: @user),
        FactoryGirl.create(:artifact, user: @user),
        FactoryGirl.create(:artifact, user: FactoryGirl.create(:user)) # another user
    ]

    get :show

    assert_equal @user, assigns(:user)
    assert_equal assigns(:artifacts).count, 3
    assert_includes assigns(:artifacts), artifacts[0]
    assert_includes assigns(:artifacts), artifacts[1]
    assert_includes assigns(:artifacts), artifacts[2]
  end

  test 'show my artifacts page for current_user (2 artifacts and 1 unapproved)' do
    sign_in(@user)

    artifacts = [
        FactoryGirl.create(:artifact, user: @user),
        FactoryGirl.create(:artifact, user: @user),
        FactoryGirl.create(:artifact, user: @user, approved: false)
    ]

    get :show

    assert_equal @user, assigns(:user)
    assert_equal assigns(:artifacts).count, 3
    assert_includes assigns(:artifacts), artifacts[0]
    assert_includes assigns(:artifacts), artifacts[1]
    assert_includes assigns(:artifacts), artifacts[2]
  end

end