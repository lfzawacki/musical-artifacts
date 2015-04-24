require 'digest/sha2'

class Artifact < ActiveRecord::Base
    mount_uploader :file, ArtifactFileUploader

    acts_as_taggable_on :software, :tags

    serialize :mirrors
    serialize :more_info_urls

    def mirrors=m
      if m.kind_of?(String)
        write_attribute(:mirrors, m.split(/[,;]/))
      else
        write_attribute(:mirrors, m)
      end
    end

    validates :name, presence: true

    validates :license, presence: true
    belongs_to :license

    before_save :generate_file_hash
    before_save :generate_file_list
    before_save :save_file_format

    def generate_file_hash
      if file.present? && file_changed?
        self.file_hash = Digest::SHA256.hexdigest(file.file.read)
      end
      true
    end

    def save_file_format
      if file_changed?
        self.file_format = file.file.try(:extension)
      end
      true
    end

    # How to get file list of all different types?
    def generate_file_list
      ext = ['zip', 'rar', '7z', 'lzma', 'tar.gz']

      if file_changed?
        self.compressed = ext.include?(file.file.try(:extension))
      end
      true
    end

    def related max=5
      self.class
      .tagged_with(software_list | tag_list , any: true)
      .where('id NOT in(?)', self.id)
      .limit(max)
    end
end
