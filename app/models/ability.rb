class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

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
      can :artifacts, User
      can :favorites, User

      can :favorite, Artifact do |artifact|
        !favorited_ids.include?(artifact.id)
      end

      can :unfavorite, Artifact do |artifact|
        favorited_ids.include?(artifact.id)
      end
    end

  end

  private

  def favorited_ids
    @favorited_ids ||= Favorite.where(user_id: @user.id).pluck(:artifact_id).to_set
  end

  def user
    @user
  end
end
