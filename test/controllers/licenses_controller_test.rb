require 'test_helper'

class LicensesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:licenses)
  end

  test "should get index as json" do
    get :index, format: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert body.kind_of?(Array)
  end

end
