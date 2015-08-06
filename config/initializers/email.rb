ActiveSupport.on_load(:after_initialize) do

  if Setting.table_exists? && Setting.first
    conf = Setting.first

    # default settings
    settings = { :address => nil, :port => 25, :domain => nil,
      :enable_starttls_auto => true, :authentication => nil, :tls => false,
      :user_name => nil, :password => nil
    }

    [:address, :port, :domain, :authentication, :user_name, :password].each do |att|

      field = conf.send(:"mail_#{att}")
      if field.present?
        settings[att] = field
      end
    end

    ActionMailer::Base.default_url_options = { :host => conf.try(:hostname) || 'localhost:3000' }
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.raise_delivery_errors = true
    ActionMailer::Base.smtp_settings = settings
  end
end