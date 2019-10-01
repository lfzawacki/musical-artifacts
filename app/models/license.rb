class License < ActiveRecord::Base
  has_many :artifacts

  def self.license_types
    License.all.pluck(:license_type).uniq
  end

  # TODO: Maybe move this whole code to attributes in the database?
  def self.type_image name, small=false
    # All gpls use the same image
    if name.match(/gpl/)
      name = 'gpl'
    end

    # Fix different versions of CC licenses
    if name.match(/^by/) && cc_license_number(name) == 3
      name = name.split('-')[0...-1].join('-')
    end

    img = "licenses/#{name}#{small ? '-small' : ''}"
    extension = nil

    # find the correct image extension
    ['svg', 'png', 'jpg'].each do |ext|
      extension = ext if license_image_present?("#{img}.#{ext}")
    end

    # Return full image path
    "#{img}.#{extension}" if extension
  end

  def self.type_name type
    type
  end

  def image_url small=false
    if license_type == 'cc'
      License.type_image(name_parts.join('-'), small)
    else
      License.type_image(short_name, small)
    end
  end

  # Override find to use the shortname and then try the ID
  def self.find(id)
    where(short_name: id).first || super
  end

  def translation_short_name
    short_name.gsub('-', '_')
  end

  def license_for_group_select
    [
      I18n.t("licenses.name.#{self.translation_short_name}"),
      self.id
    ]
  end

  # Split a CC license name in it's parts
  #   For example:
  #     by     -> ['by']
  #     by_nd  -> ['by', 'nd']
  #     by_3   -> ['by', '3']
  def name_parts
    if license_type == 'cc'
      short_name.split('-').select { |p| License.is_text_part?(p) }
    else
      []
    end
  end

  # See docs below
  def cc_license_number
    if license_type == 'cc'
      License.cc_license_number(short_name)
    end
  end

  private
  def self.license_image_present? filename
    if Rails.env.production?
      Rails.application.assets_manifest.assets[filename]
    else
      File.exists?(File.join(Rails.root, 'app/assets/images/', filename))
    end
  end

  # Test if a part of the CC license is the version number
  def License.is_text_part? part
    part.to_i.to_s != part
  end

  # Return the CC license number based on it's parts
  #  For example:
  #    by       -> 4
  #    by_3     -> 3
  #    by_sa_3  -> 3
  #    by_nd    -> 4
  def self.cc_license_number short_name
    last = short_name.split('-')[-1]
    is_text_part?(last) ? 4 : 3
  end

end
