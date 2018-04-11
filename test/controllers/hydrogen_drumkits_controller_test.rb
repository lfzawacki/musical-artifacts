require 'test_helper'

class HydrogenDrumkitsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @setting = Setting.first

    @by = License.find('by')
    @cr = License.find('copyright')
    @nc = License.find('by-nc')

    @drumkits = [
      FactoryBot.create(:artifact, software_list: 'hydrogen',
        mirrors: 'https://hydrogen-mirrors.com/mykit.h2drumkit', file_format_list: ['h2drumkit'], license: @by),
      FactoryBot.create(:artifact, software_list: 'hydrogen',
        mirrors: 'https://hydrogen-mirrors.com/your.h2drumkit', file_format_list: ['h2drumkit'], license: @nc),
      FactoryBot.create(:artifact, software_list: 'hydrogen', file: fixture_file('drumkit.h2drumkit'), license: @cr),
    ].sort_by(&:name)

    @songs = [
      FactoryBot.create(:artifact, software_list: 'hydrogen', mirrors: 'https://hydrogen-mirrors.com/mypattern.h2song',
        file_format_list: ['h2song'], license: @by),
      FactoryBot.create(:artifact, software_list: 'hydrogen', file: fixture_file('song.h2song'), license: @cr)
    ].sort_by(&:name)

    @patterns = [
      FactoryBot.create(:artifact, software_list: 'hydrogen', mirrors: 'https://hydrogen-mirrors.com/mykit.h2pattern',
        file_format_list: ['h2pattern'], license: @by),
      FactoryBot.create(:artifact, software_list: 'hydrogen', file: fixture_file('pattern.h2pattern'), license: @cr),
    ].sort_by(&:name)

    @not_hydrogen = [
      FactoryBot.create(:artifact, name: 'No h2file', software_list: 'hydrogen', file: fixture_file('under.zip')),
      FactoryBot.create(:artifact, name: 'No h2drumkit format', software_list: 'hydrogen',
        mirrors: 'https://hydrogen-mirrors.com/your.h2drumkit'),
    ].sort_by(&:name)
  end

  test "should get index and set variable with the hydrogen nodes" do
    get :index, format: :xml

    assert_response :success
    assert_not_nil assigns(:hydrogen)
    assert_not_nil assigns(:hydrogen)[:drumkit]
    assert_not_nil assigns(:hydrogen)[:pattern]
    assert_not_nil assigns(:hydrogen)[:song]

    # should not assign the last one
    assert_equal assigns(:hydrogen)[:drumkit].size, 3
    assert_equal assigns(:hydrogen)[:pattern].size, 2
    assert_equal assigns(:hydrogen)[:song].size, 2
  end

  test "should get drumkits even if format has trailing whitespaces (xml%20)" do
    get :index, format: 'xml '

    assert_response :success
    assert_equal assigns(:hydrogen)[:drumkit].size, 3
    assert_equal assigns(:hydrogen)[:pattern].size, 2
    assert_equal assigns(:hydrogen)[:song].size, 2

    get :index, format: 'xml  '

    assert_response :success
    assert_equal assigns(:hydrogen)[:drumkit].size, 3
    assert_equal assigns(:hydrogen)[:pattern].size, 2
    assert_equal assigns(:hydrogen)[:song].size, 2
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

    assigned_drumkits = assigns(:hydrogen)[:drumkit]
    assigned_patterns = assigns(:hydrogen)[:pattern]
    assigned_songs = assigns(:hydrogen)[:song]

    assert_equal assigns(:hydrogen)[:drumkit].count, 3
    assert_equal assigns(:hydrogen)[:pattern].count, 2
    assert_equal assigns(:hydrogen)[:song].count, 2

    @drumkits.each_with_index do |drumkit, i|
      assert_equal drumkit.name, assigned_drumkits[i].name
      assert_equal drumkit.author, assigned_drumkits[i].author
      assert_equal drumkit.license.name, assigned_drumkits[i].license.name
    end

    @songs.each_with_index do |song, i|
      assert_equal song.name, assigned_songs[i].name
      assert_equal song.author, assigned_songs[i].author
      assert_equal song.license.name, assigned_songs[i].license.name
    end

    @patterns.each_with_index do |pattern, i|
      assert_equal pattern.name, assigned_patterns[i].name
      assert_equal pattern.author, assigned_patterns[i].author
      assert_equal pattern.license.name, assigned_patterns[i].license.name
    end
  end

  test "filter only free licenses" do
    get :index, format: :xml, free: true
    assert_equal assigns(:hydrogen)[:drumkit].count, 1
    assert_equal assigns(:hydrogen)[:pattern].count, 1
    assert_equal assigns(:hydrogen)[:song].count, 1

    get :index, format: :xml, license: 'free'
    assert_equal assigns(:hydrogen)[:drumkit].count, 1
    assert_equal assigns(:hydrogen)[:pattern].count, 1
    assert_equal assigns(:hydrogen)[:song].count, 1
  end

  test "filter only free licenses but with the wrong parameters shouldn't work" do
    get :index, format: :xml, free: nil
    assert_equal assigns(:hydrogen)[:drumkit].count, 3
    assert_equal assigns(:hydrogen)[:pattern].count, 2
    assert_equal assigns(:hydrogen)[:song].count, 2

    get :index, format: :xml, license: 'wrong-string'
    assert_equal assigns(:hydrogen)[:drumkit].count, 3
    assert_equal assigns(:hydrogen)[:pattern].count, 2
    assert_equal assigns(:hydrogen)[:song].count, 2
  end
end
