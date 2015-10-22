class ArtifactObserver < ActiveRecord::Observer

  def after_create(artifact)
    admins = User.where(admin: true)

    # Send an email to each admin, unless it's and admin creating it
    if !admins.include?(artifact.user)

      admins.each do |user|
        ArtifactMailer.new_artifact(user, artifact).deliver_later
      end
    end

  end
end