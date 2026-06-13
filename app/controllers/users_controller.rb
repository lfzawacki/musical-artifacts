class UsersController < InheritedResources::Base

  before_filter :load_user, only: [:show, :artifacts, :favorites]
  authorize_resource

  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  respond_to :json, only: [:artifacts, :favorites]

  def artifacts
    @artifacts = @user
      .artifacts
      .includes(:license)
      .page(params[:page]).per(@setting.artifacts_per_page)
      .order('created_at DESC')

    respond_to do |format|
      format.html
      format.json { render 'artifacts/index' }
    end
  end

  def favorites
    @favorite_artifacts = @user
      .favorite_artifacts
      .includes(:license)
      .page(params[:page]).per(@setting.artifacts_per_page)
      .order('created_at DESC')

    @artifacts = @favorite_artifacts

    respond_to do |format|
      format.html
      format.json { render 'artifacts/index' }
    end
  end

  private

  def _prefixes
    super | ['artifacts']
  end

  def handle_access_denied exception
    if request.format.json?
      head :unauthorized
    elsif [:show, :artifacts, :favorites].include?(exception.action)
      redirect_to new_user_session_path
    else
      redirect_to root_path, notice: t('_other.access_denied')
    end
  end

end
