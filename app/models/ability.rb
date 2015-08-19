class Ability
  include CanCan::Ability

  def initialize(user)

    can :download, Artifact do |artifact|
      artifact.downloadable? && artifact.approved?
    end

    can :read, Artifact, approved: true
    can :read, App

    if user.present?

      can :manage, :all if user.admin?

      can :edit, Artifact do |artifact|
        artifact.user == user
      end

      can :create, Artifact
    end

  end
end
