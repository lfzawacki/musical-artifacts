require 'test_helper'

class AppsControllerTest < ActionController::TestCase
  setup do
    @app = FactoryGirl.create(:app)
    @user = FactoryGirl.create :user, email: 'billy@aperfectcircle.com', password: 'missingmoment'
    @admin = FactoryGirl.create :user, email: 'maynard@toolband.com', password: 'thisbodyholdingme', admin: true
  end

  test "should get index" do
    # get :index
    # assert_response :success
  end

  test "should show app" do
    # get :show, id: @app
    # assert_response :success
  end

end
