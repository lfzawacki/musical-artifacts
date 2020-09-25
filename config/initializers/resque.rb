Resque.inline = Rails.env.test?

Resque.redis = ENV['REDIS_HOST']

class CanAccessResque
  def self.matches?(request)
    current_user = request.env['warden'].user
    Ability.new(current_user).can? :manage, Resque
  end
end
