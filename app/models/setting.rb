class Setting < ActiveRecord::Base
  def self.data_attributes
    [:hostname, :site_name, :juvia_site_key, :juvia_server_url, :juvia_include_css, :juvia_comment_order, :api_throttle_per_minute,
     :mail_sender, :mail_address, :mail_port, :mail_domain, :mail_authentication, :mail_user_name, :mail_password,
     :exception_recipients, :artifacts_per_page,
     :min_tag_search, :min_app_search, :min_format_search,
     :max_tag_results, :max_app_results, :max_format_results]
  end
  store_accessor :data, Setting.data_attributes
end
