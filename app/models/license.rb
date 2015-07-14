class License < ActiveRecord::Base
  has_many :artifacts

  def image_url small=false
    "licenses/#{short_name}#{small ? '-small' : ''}.svg"
  end

  # Override find to use the shortname and then try the ID
  def self.find(id)
    where(short_name: id).first || super
  end
end
