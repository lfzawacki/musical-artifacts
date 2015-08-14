class Ability
  include CanCan::Ability

  def initialize(user)

    if user.present?

      can :manage, :all if user.admin?
      can :create, Artifact
    end

    can :read, Artifact, approved: true
    can :read, App

    can :download, Artifact, downloadable: true
  end
end
