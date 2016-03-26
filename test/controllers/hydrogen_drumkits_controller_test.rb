require 'test_helper'

class HydrogenDrumkitsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @setting = Setting.first
    @drumkits = [
      FactoryGirl.create(:artifact, software_list: 'hydrogen', mirrors: 'https://hydrogen-mirrors.com/mykit.h2drumkit'),
      FactoryGirl.create(:artifact, software_list: 'hydrogen', mirrors: 'https://hydrogen-mirrors.com/your.h2drumkit'),
      FactoryGirl.create(:artifact, software_list: 'hydrogen', file: fixture_file('drumkit.h2drumkit')),
    ]

    @not_drumkit = FactoryGirl.create(:artifact, software_list: 'hydrogen', file: fixture_file('under.zip'))

    @by = License.find('by')
  end

  test "should get index and set variable with the drumkits (with xml format)" do
    get :index, format: :xml

    assert_response :success
    assert_not_nil assigns(:drumkits)

    # should not assign the last one
    assert_equal assigns(:drumkits).size, 3
  end

  test "should get drumkits even if format has trailing whitespaces (xml%20)" do
    get :index, format: 'xml '

    assert_response :success
    assert_equal assigns(:drumkits).size, 3

    get :index, format: 'xml  '

    assert_response :success
    assert_equal assigns(:drumkits).size, 3
  end

  test "dont render for other random formats" do
    assert_raises(ActionController::UnknownFormat) do
      get :index, format: :json
    end

    assert_raises(ActionController::UnknownFormat) do
      get :index, format: :html
    end
  end

  test "hydrogen xml format" do
    get :index, format: :xml

    @drumkits.each_with_index do |drumkit, i|
      assert_equal drumkit.name, assigns(:drumkits)[i][:name]
      assert_equal drumkit.author, assigns(:drumkits)[i][:author]
      assert_equal drumkit.license.name, assigns(:drumkits)[i][:license]
    end
  end
end
