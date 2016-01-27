class ActivitiesController < ApplicationController

  def index
    @activities = PublicActivity::Activity.all.order('created_at DESC')
    @activities = @activities.page(params[:page]).per(20)
  end

end
