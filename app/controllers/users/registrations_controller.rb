class Users::RegistrationsController < ActiveAdmin::Devise::RegistrationsController
  layout 'application'

  before_action :permit_params

  def permit_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :password, :password_confirmation)
    end
  end

end