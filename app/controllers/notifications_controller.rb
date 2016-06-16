class NotificationsController < ApplicationController

  def dismiss

    # Don't show it for the next entire day
    if params[:notification_type].present?
      session[:notifications][params[:notification_type].to_sym] = DateTime.now + 1.day
    end

    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end

end
