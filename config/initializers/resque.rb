Resque.inline = Rails.env.test?

class CanAccessResque
  def self.matches?(request)
    current_user = request.env['warden'].user
    Ability.new(current_user).can? :manage, Resque
  end
end