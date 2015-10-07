class FavoritesController < ApplicationController
  before_filter :custom_load_and_authorize, only: [:create, :destroy]

  respond_to :json

  def create
    @success = @favorite.save

    respond_with do |format|
      format.html { redirect_to artifact_path(@artifact) }
      format.json
    end
  end

  def destroy
    @success = false
    if @favorite.destroy
      @success = true
    end

    respond_with do |format|
      format.html { redirect_to artifact_path(@artifact) }
      format.json
    end
  end

  # Kind of bypassed the cancan behaviors here so I could use :favorite and :unfavorite
  # so I've just created some similar functions that act like cancan would
  def custom_load_and_authorize
    load_user # from application controller
    @artifact = Artifact.find(params[:artifact_id])
    @ability = Ability.new(@user)

    if action_name == 'create' && @ability.can?(:favorite, @artifact)
      @favorite = Favorite.new(artifact: @artifact, user: @user)

    elsif action_name == 'destroy' && @ability.can?(:unfavorite, @artifact)
      @favorite = Favorite.where(artifact: @artifact, user: @user).first

    else
      raise CanCan::AccessDenied.new(nil, action_name, Favorite)
    end
  end

  def handle_access_denied exception
    if ['create', 'destroy'].include?(exception.action)
      redirect_to new_user_session_path, notice: I18n.t('favorites.access_denied')
    end
  end

end
