class ArtifactMailer < ApplicationMailer

  def new_artifact(user, artifact)
    @artifact = artifact
    Rails.logger.info "[ArtifactMailer] sending mail to #{user.email}"
    mail(to: user.email, subject: 'New artifact created')
  end

end
