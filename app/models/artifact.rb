require 'digest/sha2'

class Artifact < ActiveRecord::Base
    mount_uploader :file, ArtifactFileUploader

    acts_as_taggable_on :software, :tags

    serialize :mirrors

    def mirrors=m
      if m.kind_of?(String)
        write_attribute(:mirrors, m.split(/[,;]/))
      else
        write_attribute(:mirrors, m)
      end
    end

    validates :name, presence: true

    belongs_to :license

    before_save :generate_file_hash
    before_save :generate_file_list

    def generate_file_hash
      if file_changed?
        self.file_hash = Digest::SHA256.hexdigest(file.file.read)
      end
    end

    def generate_file_list
      ext = ['zip', 'rar', '7z', 'lzma', 'tar.gz']

      if file_changed?
        self.compressed = ext.include?(file.file.extension)
      end
    end
end
