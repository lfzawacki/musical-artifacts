require 'exception_notification/rails'

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |exception, options|
    not Rails.env.production?
  end

  conf = nil # Settings
  if Setting.table_exists?
    conf = Setting.first
  end

  # Email notifier sends notifications by email.
  config.add_notifier :email, {
   :email_prefix     => "#{conf.try(:site_name).try(:downcase) || 'musical artifacts'}",
   :sender_address    => [" \"#{conf.try(:site_name) || "Musical Artifacts"}\" <#{conf.try(:mail_sender) || "noreply@musical-artifacts.com"}>"],
   :exception_recipients => conf.try(:exception_recipients).try(:split, /,;/) || []
  }

  # Webhook notifier sends notifications over HTTP protocol. Requires 'httparty' gem.
  # config.add_notifier :webhook, {
  #   :url => 'http://example.com:5555/hubot/path',
  #   :http_method => :post
  # }

end
