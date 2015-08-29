class License < ActiveRecord::Base
  has_many :artifacts

  def image_url small=false
    name = short_name

    # All gpls use the same image
    if name.match(/gpl/)
      name = 'gpl'
    end

    img = "licenses/#{name}#{small ? '-small' : ''}"
    extension = 'svg'

    # find the correct image extension
    ['svg', 'png', 'jpg'].each do |ext|
      extension = ext if Rails.application.assets.find_asset("#{img}.#{ext}")
    end

    # Return full image path
    "#{img}.#{extension}"
  end

  # Override find to use the shortname and then try the ID
  def self.find(id)
    where(short_name: id).first || super
  end
end
