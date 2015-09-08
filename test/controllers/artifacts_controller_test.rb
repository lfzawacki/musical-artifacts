require 'test_helper'

class ArtifactsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @setting = Setting.first
    @artifact = FactoryGirl.create(:artifact)

    @user = FactoryGirl.create(:user, email: 'frederik@opeth.se', password: 'lotuseater')
    @admin = FactoryGirl.create(:user, email: 'mikael@opeth.se', password: 'demonofthefall', admin: true)

    @by = License.find('by')
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artifacts)
  end

  test "different kinds of searches" do
    skip
  end

  test ".json searches" do
    skip
  end

  test "should ask for login on new" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should show new for logged in user" do
    sign_in(@user)
    get :new

    assert_response :success
  end

  test "should show new for admin" do
    sign_in(@admin)
    get :new

    assert_response :success
  end

  test "should create artifact as admin" do
    sign_in(@admin)

    assert_difference('Artifact.approved.count', 1) do
      post :create, artifact:
        { name: 'Acoustic passages', author: 'Mikael', description: 'Classical guitar acoustic passages', license_id: @by.id }
    end

    assert_redirected_to artifact_path(assigns(:artifact))
    assert_equal flash[:notice], I18n.t('artifacts.create.success')
    assert_equal Artifact.last.user, @admin
  end

  test "should create unapproved artifact as a normal user" do
    sign_in(@user)

    assert_difference('Artifact.count', 1) do
      post :create, artifact:
        { name: 'Death metal riffs', author: 'Mikael', description: 'Bathory like death metal riffs', license_id: @by.id }
    end

    assert_redirected_to artifacts_path
    assert_equal flash[:notice], I18n.t('artifacts.create.not_approved')
    assert_equal Artifact.last.user, @user
  end

  test "should show artifact" do
    get :show, id: @artifact
    assert_response :success
  end

  test "should not show unapproved artifact to logged out user" do
    @artifact.update_attributes approved: false

    get :show, id: @artifact
    assert_redirected_to artifacts_path
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

  test "should not show unapproved artifact to normal user" do
    sign_in(@user)
    @artifact.update_attributes approved: false

    get :show, id: @artifact
    assert_redirected_to artifacts_path
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

  test "should get edit as admin" do
    sign_in(@admin)

    get :edit, id: @artifact
    assert_response :success
  end

  test "should not get edit as logged out user" do
    get :edit, id: @artifact
    assert_redirected_to artifact_path(@artifact)
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

  test "should not get edit as normal user" do
    sign_in(@user)

    get :edit, id: @artifact
    assert_redirected_to artifact_path(@artifact)
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

  test "should get edit as normal user who created the artifact" do
    sign_in(@user)
    @artifact.update_attributes user: @user

    get :edit, id: @artifact
    assert_response :success
  end

  test "should download artifact with correct link" do
    @artifact.update_attributes(file: fixture_file('example.gx'))

    assert_difference('StoredFile.last.download_count', 1) do
      get :download, id: @artifact, filename: 'example.gx'
    end

    assert_response :success
  end

  test "should render 404 with wrong link" do
    @artifact.update_attributes(file: fixture_file('example.gx'))

    assert_difference('StoredFile.last.download_count', 0) do
      get :download, id: @artifact, filename: 'inexistent.gx'
    end

    assert_response 404
  end

  test "should not download artifact if downloadable=false" do
    @artifact.update_attributes(file: fixture_file('example.gx'), downloadable: false)

    assert_difference('StoredFile.last.download_count', 0) do
      get :download, id: @artifact, filename: 'example.gx'
    end

    assert_redirected_to artifact_path(@artifact)
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

  test "should not download artifact if approved=false" do
    @artifact.update_attributes(file: fixture_file('example.gx'), approved: false)

    assert_difference('StoredFile.last.download_count', 0) do
      get :download, id: @artifact, filename: 'example.gx'
    end

    assert_redirected_to artifact_path(@artifact)
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

  test "user should not download artifact if downloadable=false" do
    sign_in(@user)
    @artifact.update_attributes(file: fixture_file('example.gx'), downloadable: false)

    assert_difference('StoredFile.last.download_count', 0) do
      get :download, id: @artifact, filename: 'example.gx'
    end

    assert_redirected_to artifact_path(@artifact)
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

  test "admin should download artifact even if downloadable=false" do
    sign_in(@admin)
    @artifact.update_attributes(file: fixture_file('example.gx'), downloadable: false)

    assert_difference('StoredFile.last.download_count', 1) do
      get :download, id: @artifact, filename: 'example.gx'
    end

    assert_response :success
  end

  test "should update artifact as admin" do
    sign_in(@admin)

    patch :update, id: @artifact, artifact:
      { author: @artifact.author, description: @artifact.description,
        file_hash: @artifact.file_hash, name: @artifact.name }

    assert_redirected_to artifact_path(assigns(:artifact))
  end

  test "should not update artifact as normal user" do
    sign_in(@user)

    patch :update, id: @artifact, artifact:
      { author: @artifact.author, description: @artifact.description,
        file_hash: @artifact.file_hash, name: @artifact.name }

    assert_redirected_to artifact_path(@artifact)
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

  test "should update artifact as normal user who is the creator" do
    sign_in(@user)
    @artifact.update_attributes user: @user

    patch :update, id: @artifact, artifact:
      { author: @artifact.author, description: @artifact.description,
        file_hash: @artifact.file_hash, name: @artifact.name }

    assert_redirected_to artifact_path(assigns(:artifact))
  end

  test "should not destroy artifact as normal user" do
    sign_in(@user)

    assert_difference('Artifact.count', 0) do
      delete :destroy, id: @artifact
    end
  end

  test "should destroy artifact as admin" do
    sign_in(@admin)

    assert_difference('Artifact.count', -1) do
      delete :destroy, id: @artifact
    end

    assert_redirected_to artifacts_path
  end

  test "should render show in json format" do
    skip
  end

  test "should render index in json format" do
    skip
  end
end
