class Users::RegistrationsController < ActiveAdmin::Devise::RegistrationsController
  layout 'application'

  before_action :permit_params

  def permit_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
  end

end
