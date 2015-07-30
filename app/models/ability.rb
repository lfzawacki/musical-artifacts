class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :manage, :all
    else
      can :read, :all

      can :download, Artifact
    end
  end
end
