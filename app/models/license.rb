class License < ActiveRecord::Base
  has_many :artifacts

  def self.license_types
    License.all.pluck(:license_type).uniq
  end

  # TODO: Maybe move this whole code to attributes in the database?
  def self.type_image type, small=false
    name = type

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

  def self.type_name type
    type
  end

  def image_url small=false
    License.type_image(short_name, small)
  end

  # Override find to use the shortname and then try the ID
  def self.find(id)
    where(short_name: id).first || super
  end
end
