require 'rack/throttle'

class ApiThrottle < Rack::Throttle::Minute
  ##
  # Returns `false` if the rate limit has been exceeded for the given
  # `request`, or `true` otherwise.
  #
  # Rate limits are only imposed on the artifacts and apps controllers
  #
  # @param  [Rack::Request] request
  # @return [Boolean]
  def initialize app, options={}
    if ActiveRecord::Base.connection.table_exists? 'settings'
      throttling = Setting.first.try(:api_throttle_per_minute).try(:to_i)
      options[:max] = throttling if throttling.present?
    end
    super
  end

  def allowed?(request)
    path_info = (Rails.application.routes.recognize_path request.url rescue {}) || {}

    # Check if this route should be rate-limited
    if path_info[:controller] == "artifacts" || path_info[:controller] == "apps"
      super
    else
      # other routes are not throttled, so we allow them
      true
    end
  end
end