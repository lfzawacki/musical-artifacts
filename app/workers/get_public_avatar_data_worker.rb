class GetPublicAvatarDataWorker
  @queue = :low

  # Tries to get username/avatar from gravatar (actually libravatar)
  def self.perform(user_id)
    user = User.find(user_id)

    # Only fetch from users who registered with email
    puts "* [avatar] Fetching username/avatar for #{user.email.truncate(8)}"
    if user.provider.blank?
      md5 = Digest::MD5.hexdigest(user.email)
      url = URI("https://secure.gravatar.com/profile/#{md5}.json")

      json = {}
      begin
        body = Net::HTTP.get(url)
        json = JSON.parse(body) if body != "User not found"
      rescue
        # catch any exception
      end

      user.username ||= json["displayName"]
      user.avatar ||= "https://seccdn.libravatar.org/avatar/#{md5}.png"

      user.save(validate: false)
    end
  end
end