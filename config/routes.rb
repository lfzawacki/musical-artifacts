Rails.application.routes.draw do
  root to: "artifacts#index"

  devise_for :users, ActiveAdmin::Devise.config

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  resources :licenses

  resources :artifacts

  resources :searches, only: [] do
    collection do
      get :tags
      get :software
    end
  end
end
