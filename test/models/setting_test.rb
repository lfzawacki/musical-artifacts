require "test_helper"

class SettingTest < ActiveSupport::TestCase

  def setting
    @setting ||= Setting.new
  end

  def test_valid
    assert setting.valid?
  end

  def test_data_attributes
    expected_attributes = [
      :hostname, :site_name, :juvia_site_key, :juvia_server_url, :juvia_include_css, :juvia_comment_order, :api_throttle_per_minute,
      :mail_sender, :mail_address, :mail_port, :mail_domain, :mail_authentication, :mail_user_name, :mail_password,
      :exception_recipients, :artifacts_per_page,
      :max_artifact_tags, :max_artifact_apps, :max_artifact_formats,
      :min_tag_search, :min_app_search, :min_format_search,
      :max_tag_results, :max_app_results, :max_format_results,
      :enable_related_artifacts, :simple_tag_searches
    ]
    assert_equal expected_attributes.sort, Setting.data_attributes.sort
  end

  def test_enable_related_artifacts
    setting.enable_related_artifacts = true
    assert setting.enable_related_artifacts?

    setting.enable_related_artifacts = false
    assert_not setting.enable_related_artifacts?
  end

  def test_simple_tag_searches
    setting.simple_tag_searches = true
    assert setting.simple_tag_searches?

    setting.simple_tag_searches = false
    assert_not setting.simple_tag_searches?
  end

end
