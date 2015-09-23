class UsersController < InheritedResources::Base

  before_filter :load_user, only: [:show]
  authorize_resource
  before_filter :load_artifacts, only: [:show]
  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  respond_to :json

  private

  def handle_access_denied exception
    if request.format.json?
      head :unauthorized
    elsif [:show].include?(exception.action)
      redirect_to new_user_session_path
    else
      redirect_to root_path, notice: t('_other.access_denied')
    end
  end

  def load_user
    @user = current_user
  end

  def load_artifacts
    @artifacts = @user.artifacts.page(params[:page]).per(20).order('created_at DESC')
  end
end
