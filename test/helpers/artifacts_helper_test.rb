require "test_helper"

class ArtifactsHelperTest < ActionView::TestCase

  test ".value_from_params" do
    controller.params[:q] = 'bamboo flute'
    assert_equal 'bamboo flute', value_from_params
  end

  test ".title_from_tags with array params does not raise" do
    tags = { formats: ['sf2'], tags: ['bamboo', 'flute'], apps: ['linuxsampler'] }
    assert_equal 'Linuxsampler bamboo flute .sf2', title_from_tags(tags)
  end

  test ".unescape_separators with array value does not raise" do
    assert_equal ' ,,,normal', unescape_separators(['%20', '%2C', 'normal'])
  end

  test ".external_link_to" do
    skip
  end

  test ".domain_from_link" do
    skip
  end

  test ".format_from_link" do
    skip
  end

  test ".icon_from_extension" do
    skip
  end

  test ".display_license" do
    skip
  end

  test ".unescape_separators" do
    assert_equal 'hello world,dude', unescape_separators('hello%20world%2Cdude')
    assert_equal '', unescape_separators('')
    assert_equal '', unescape_separators(nil)
  end

  test '.download_link' do
    skip
  end

  test '.download_url' do
    skip
  end

  test '.hash_list_tag' do
    skip
  end

  test '.file_tree' do
    skip
  end

end
