class Ability
  include CanCan::Ability

  def initialize(user)

    can :download, Artifact do |artifact|
      artifact.downloadable? && artifact.approved?
    end

    can :read, Artifact, approved: true
    can :read, App

    if user.present?

      if user.admin?
        can :manage, :all
        cannot [:favorite, :unfavorite], Artifact
      end

      if user.donated?
	can :preview, Artifact
      end

      can [:edit, :update, :show, :download], Artifact do |artifact|
        artifact.owned_by?(user)
      end

      can :create, Artifact

      can :show, User

      can :favorite, Artifact do |artifact|
        Favorite.where(artifact_id: artifact.id, user_id: user.id).empty?
      end

      can :unfavorite, Artifact do |artifact|
        Favorite.where(artifact_id: artifact.id, user_id: user.id).any?
      end
    end

  end
end
