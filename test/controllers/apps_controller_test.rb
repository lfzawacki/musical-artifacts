require 'test_helper'

class AppsControllerTest < ActionController::TestCase
  setup do
    @app = FactoryBot.create(:app)
    @user = FactoryBot.create :user, email: 'billy@aperfectcircle.com', password: 'missingmoment'
    @admin = FactoryBot.create :user, email: 'maynard@toolband.com', password: 'thisbodyholdingme', admin: true
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
