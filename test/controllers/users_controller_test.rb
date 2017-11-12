require "test_helper"

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = FactoryBot.create(:user, email: 'mrwilson@porcupi.ne', password: 'signify trees')
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
        FactoryBot.create(:artifact, user: @user),
        FactoryBot.create(:artifact, user: @user),
        FactoryBot.create(:artifact, user: @user),
        FactoryBot.create(:artifact, user: FactoryBot.create(:user)) # another user
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
        FactoryBot.create(:artifact, user: @user),
        FactoryBot.create(:artifact, user: @user),
        FactoryBot.create(:artifact, user: @user, approved: false)
    ]

    get :show

    assert_equal @user, assigns(:user)
    assert_equal assigns(:artifacts).count, 3
    assert_includes assigns(:artifacts), artifacts[0]
    assert_includes assigns(:artifacts), artifacts[1]
    assert_includes assigns(:artifacts), artifacts[2]
  end

  #
  # -- JSON API tests
  #
  test "should not render show in json format without api authentication" do
    get :show, format: :json

    assert_response :unauthorized
  end

  test "should render show in json format and with no artifacts" do
    api_authenticate(@user)

    get :show, format: :json

    assert_response :success
    assert_equal json_body.size, 0
  end

  test "should render show in json format and with 2 artifacts" do
    api_authenticate(@user)

    artifacts = [ FactoryBot.create(:artifact, user: @user), FactoryBot.create(:artifact, user: @user) ]

    get :show, format: :json

    assert_response :success
    assert_equal json_body.size, 2
    assert_equal artifacts[1].name, json_body[0]['name']
    assert_equal artifacts[0].name, json_body[1]['name']
  end

end
