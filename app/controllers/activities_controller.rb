class ActivitiesController < ApplicationController

  def index
    @activities = PublicActivity::Activity
      .includes(:owner).includes(:trackable)
      .where(trackable_type: 'Artifact')
      .where.not(trackable_id: Artifact
      .where(approved: false))

    @activities = @activities.order('created_at DESC')
    @activities = @activities.page(params[:page]).per(20)
  end

end
