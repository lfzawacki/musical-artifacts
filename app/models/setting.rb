class Setting < ActiveRecord::Base
  def self.data_attributes
    [:hostname, :site_name, :juvia_site_key, :juvia_server_url, :juvia_include_css, :juvia_comment_order]
  end
  store_accessor :data, Setting.data_attributes
end
