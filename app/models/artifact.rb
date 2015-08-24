require 'digest/sha2'

class Artifact < ActiveRecord::Base
    include AutoHtml

    scope :approved, -> { where(approved: true) }

    acts_as_taggable_on :software, :tags, :file_formats

    serialize :mirrors
    serialize :more_info_urls

    # The creator of the artifact on the site, not the author
    belongs_to :user

    has_many :stored_files

    validates :name, presence: true

    validates :license, presence: true
    belongs_to :license

    # Search fields to be used in views, controllers, ...
    def self.search_fields
      ['license', 'tags', 'apps', 'hash', 'formats']
    end

    before_save :generate_file_hash
    def generate_file_hash
      if file.present? && file_hash.blank?
        self.file_hash = Digest::SHA256.hexdigest(file.file.read)
      end
      true
    end

    before_save :save_new_file
    def save_new_file
      if @new_file
        stored_files.last.save
        file_format_list.add stored_files.last.format
      end
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

    # Get a markdown generated HTML from the artifact description
    def description_html
      auto_html(description) {
        html_escape
        redcarpet
      }
    end

    # Get the links which can be shown as multimedia content
    def multimedia_content
      return [] if more_info_urls.blank?

      multimedia = more_info_urls.map do |link|
        auto_html(link) {
          youtube
          vimeo
          audio
          soundcloud(width: 420, height: 315, show_artwork: true, show_comments: true)
          image
        }
      end

      # Links with multimedia without the normal links
      multimedia -= more_info_urls
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
