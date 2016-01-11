class ArtifactCreatedNotificationWorker
  @queue = :low

  def self.perform(artifact_id)
    artifact = Artifact.find(artifact_id)
    admins = User.where(admin: true)

    # Send an email to each admin, unless it's and admin creating it
    if !admins.include?(artifact.user)

      admins.each do |user|
        Resque.logger.info(" * [Artifact] Sending notification for '#{artifact.name}' to '#{user.email}'")
        ArtifactMailer.new_artifact(user, artifact).deliver_later
      end
    end

  end
end