require 'digest/sha2'

class Artifact < ActiveRecord::Base
    mount_uploader :file, ArtifactFileUploader

    validates :name, presence: true

    before_save :generate_file_hash
    before_save :generate_file_list

    belongs_to :license

    def generate_file_hash
      if file.changed?
        self.file_hash = Digest::SHA256.hexdigest(file.file.read)
      end
    end

    def generate_file_list
      ext = ['zip', 'rar', '7z', 'lzma', 'tar.gz']

      if file.changed?
        self.compressed = ext.include?(file.file.extension)
      end
    end
end
