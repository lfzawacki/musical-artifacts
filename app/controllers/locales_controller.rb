class LocalesController < ApplicationController

  def set_locale

    if I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end

    if request.referer.present?
      redirect_to :back
    else
      redirect_to root_path
    end
  end

end
