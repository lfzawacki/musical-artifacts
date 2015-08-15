require 'digest/sha2'

class Artifact < ActiveRecord::Base
    scope :approved, -> { where(approved: true) }

    acts_as_taggable_on :software, :tags, :file_formats

    serialize :mirrors
    serialize :more_info_urls
    serialize :file_formats

    has_many :stored_files

    validates :name, presence: true

    validates :license, presence: true
    belongs_to :license

    before_save :generate_file_hash
    def generate_file_hash
      if file.present? && file_hash.blank?
        self.file_hash = Digest::SHA256.hexdigest(file.file.read)
      end
      true
    end

    after_save :save_new_file
    def save_new_file
      stored_files.last.save if @new_file
    end

    def file= file_io
      @new_file = true
      stored_files << StoredFile.new(file: file_io)
    end

    def file
      stored_files.last.try(:file)
    end

    def get_file_by_name filename
      stored_files.where(file: filename).first
    end

    def file_name
      stored_files.last.name
    end

    def file_format
      file_format_list.first
    end

    def file_format= format
      file_format_list.add format
    end

    def mirrors=m
      if m.kind_of?(String)
        write_attribute(:mirrors, m.split(/[,;]/))
      else
        write_attribute(:mirrors, m)
      end
    end

    def more_info_urls=m
      if m.kind_of?(String)
        write_attribute(:more_info_urls, m.split(/[,;]/))
      else
        write_attribute(:more_info_urls, m)
      end
    end

    def related max=5
      self.class
      .tagged_with(software_list | tag_list , any: true)
      .where('id NOT in(?)', self.id)
      .limit(max)
    end

    def download_path
      if stored_files.last.present?
        "/artifacts/#{to_param}/#{stored_files.last.name}"
      end
    end
end
