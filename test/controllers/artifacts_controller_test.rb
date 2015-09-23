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
    assert_equal assigns(:artifacts).size, 1
  end

  test "should get index with 3 artifacts" do
    FactoryGirl.create(:artifact)
    FactoryGirl.create(:artifact)

    get :index

    assert_response :success
    assert_not_nil assigns(:artifacts)
    assert_equal assigns(:artifacts).size, 3
  end

  test "should get index and not include unapproved" do
    FactoryGirl.create(:artifact)
    unapproved = FactoryGirl.create(:artifact, approved: false)

    get :index

    assert_response :success
    assert_not_nil assigns(:artifacts)
    assert_equal assigns(:artifacts).size, 2
    refute_includes assigns(:artifacts), unapproved
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

    assert_redirected_to artifact_path(assigns(:artifact))
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

  test "should show unapproved artifact to artifact's creator" do
    sign_in(@user)
    @artifact.update_attributes approved: false, user: @user

    get :show, id: @artifact

    assert_response :success
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

  test "creator should download artifact no matter what" do
    sign_in(@user)
    @artifact.update_attributes(user: @user, file: fixture_file('example.gx'), approved: false, downloadable: false)

    assert_difference('StoredFile.last.download_count', 1) do
      get :download, id: @artifact, filename: 'example.gx'
    end

    assert_response :success
  end

  test "should update artifact as admin" do
    sign_in(@admin)

    author = 'Coheed'
    patch :update, id: @artifact, artifact: { author: author }

    assert_redirected_to artifact_path(@artifact)
    assert_equal assigns(:artifact).author, author
  end

  test "should not update artifact as normal user" do
    sign_in(@user)

    patch :update, id: @artifact, artifact: { author: @artifact.author }

    assert_redirected_to artifact_path(assigns(:artifact))
    assert_equal flash[:notice], I18n.t('_other.access_denied')
  end

  test "should update artifact as normal user who is the creator" do
    sign_in(@user)
    @artifact.update_attributes user: @user

    new_desc = 'So bye bye world'
    patch :update, id: @artifact, artifact: { description: new_desc }

    assert_redirected_to artifact_path(assigns(:artifact))
    assert_equal assigns(:artifact).description, new_desc
  end

  test "should update unapproved artifact as normal user who is the creator" do
    sign_in(@user)
    @artifact.update_attributes user: @user, approved: false

    new_desc = 'What did I do to deserve? OOOOOH-OOOOH-OH-OH-OOOOH'
    patch :update, id: @artifact, artifact: { description: new_desc }

    assert_redirected_to artifact_path(assigns(:artifact))
    assert_equal assigns(:artifact).description, new_desc
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

  #
  # -- JSON API tests
  #
  test "should render index in json format" do
    get :index, format: :json
    assert_response :success
    assert_equal json_body.size, 1
  end

  test ".json simple search" do
    FactoryGirl.create(:artifact, name: 'Sunset Superman')
    FactoryGirl.create(:artifact, name: 'Two Suns in the Sunset')
    get :index, q: 'sunset', format: :json

    assert_response :success
    assert_equal json_body.size, 2
  end

  test "should render show in json format" do
    get :show, id: @artifact.id, format: :json
    assert_response :success
  end

  test "should not create without api_authenticate" do
    params = FactoryGirl.attributes_for(:artifact, license_id: @by.id)

    assert_difference('Artifact.count', 0) do
      post :create, artifact: params, format: :json
    end

    assert_response :unauthorized
  end

  test "should create an artifact with valid params" do
    api_authenticate(@user)
    params = FactoryGirl.attributes_for(:artifact, license_id: @by.id)

    assert_difference('Artifact.count', 1) do
      post :create, artifact: params, format: :json
    end

    assert_response :success
    assert_equal Artifact.last.user, @user
    assert_equal Artifact.last.approved, false
    assert_equal json_body['name'], params[:name]
    assert_equal json_body['author'], params[:author]
    assert_equal json_body['license'], @by.short_name
  end

  test "should create an artifact with tags and app tags" do
    api_authenticate(@user)

    params = FactoryGirl.attributes_for(:artifact, license_id: @by.id)
    params.merge!({tag_list: 'guitar, heavy metal', software_list: 'guitarix'})

    assert_difference('Artifact.count', 1) do
      post :create, artifact: params, format: :json
    end

    assert_response :success
    assert_includes Artifact.last.tag_list, 'guitar'
    assert_includes Artifact.last.tag_list, 'heavy metal'
    assert_includes Artifact.last.software_list, 'guitarix'
  end

  test "should create an artifact with tags, app tags and file" do
    api_authenticate(@user)

    params = FactoryGirl.attributes_for(:artifact, license_id: @by.id)
    params.merge!({tag_list: 'synth, wubwub, bass', software_list: 'helm'})

    assert_difference('Artifact.count', 1) do
      post :create, artifact: params, format: :json
    end

    assert_response :success

    assert_includes Artifact.last.tag_list, 'synth'
    assert_includes Artifact.last.tag_list, 'wubwub'
    assert_includes Artifact.last.tag_list, 'bass'
    assert_includes Artifact.last.software_list, 'helm'
  end

  test "should not create an artifact with invalid params (missing author)" do
    api_authenticate(@user)

    assert_difference('Artifact.count', 0) do
      post :create, artifact: {name: 'Van Der Graaf Generation', license_id: @by.id}, format: :json
    end

    assert_response :unprocessable_entity
    refute_nil json_body['errors']['author']
  end

  test "should not create an artifact with invalid params (missing license_id, name)" do
    api_authenticate(@user)

    assert_difference('Artifact.count', 0) do
      post :create, artifact: {author: 'An music software user'}, format: :json
    end

    assert_response :unprocessable_entity
    refute_nil json_body['errors']['license']
    refute_nil json_body['errors']['name']
  end

end