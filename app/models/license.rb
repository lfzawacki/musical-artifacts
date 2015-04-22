class License < ActiveRecord::Base
    has_many :artifacts

    def image_url small=false
      "licenses/#{short_name}#{small ? '-small' : ''}.svg"
    end
end
