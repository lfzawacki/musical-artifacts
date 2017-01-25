require 'digest/sha2'

class Artifact < ActiveRecord::Base
    include AutoHtml

    # TODO: extract out to another file?
    # Collect activity from creates, edits and deletions
    include PublicActivity::Model
    tracked owner: Proc.new { |ctrl, model| model.set_owner_from_current_user(ctrl) },
      params: {
        changed: Proc.new { |ctrl, model| model.track_updated_parameters(ctrl) },
        name: Proc.new { |ctrl, model| model.name }
      }

    # Only track activity in these parameters
    def self.tracked_parameters
      %w{name description author file mirrors more_info_urls tag_list software_list file_format_list license}
    end

    scope :approved, -> { where(approved: true) }

    acts_as_taggable_on :software, :tags, :file_formats

    serialize :mirrors
    serialize :more_info_urls

    after_create :enqueue_notification

    # Automatically set some app_tags based on
    # the format of the uploaded file
    after_create :set_app_tags_from_format
    def set_app_tags_from_format
      apps = App.tagged_with(file_format, on: 'file_formats')
      app_tags = apps.map(&:software_list).flatten

      self.software_list.push(*app_tags)
    end

    # The creator of the artifact on the site, not the author
    belongs_to :user
    def owned_by?(user)
      self.user_id.present? && user.id == user_id
    end

    has_many :favorites

    has_many :stored_files

    validates :name, presence: true, uniqueness: true
    validates :author, presence: true

    validates :license, presence: true
    belongs_to :license

    # Search fields to be used in views, controllers, ...
    def self.search_fields
      ['license', 'tags', 'apps', 'hash', 'formats']
    end

    # If a user has had 3 or more artifacts approved it cnn be auto approved
    # TODO: Not sure if we'll keep this system, but it's here for now
    def self.approved_count_for_trust
      3
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
        # TODO: prevent update activity on creation of artifact
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

    # Returns true if a new file has been uploaded to the artifact
    def file_changed?
      @new_file.present?
    end

    def get_file_by_name filename
      stored_files.where(file: filename).order('created_at DESC').first
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
        js_email
        link
      }
    end

    # Get an html escaped version but transform links into tags
    def extra_license_text_html
      auto_html(extra_license_text) {
        html_escape
        link
      }
    end

    # Get the links which can be shown as multimedia content
    def multimedia_content
      return [] if more_info_urls.blank?

      multimedia = more_info_urls.map do |link|
        auto_html(link) {
          youtube(width: 360)
          vimeo
          audio
          soundcloud(width: 360, height: 315, show_artwork: true, show_comments: true)
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

    def set_owner_from_current_user controller
      controller.try(:current_user) || self.user
    end

    # Returns and array of the parameters which were just updated in this object
    def track_updated_parameters controller
      if controller.present? && controller.action_name == 'update'
        changed = self.changes.keys & Artifact.tracked_parameters

        # file is not really an artifact attribute, so adding it separetely
        changed << 'file' if self.file_changed?

        changed
      end
    end

    private

    def enqueue_notification
      Resque.enqueue(ArtifactCreatedNotificationWorker, self.id)
    end
end
