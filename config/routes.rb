Rails.application.routes.draw do
  put '/settings', to: 'settings#update', as: 'settings'
  get '/settings', to: 'settings#edit', as: 'edit_settings'

  resources :apps, only: [:show, :index]

  root to: "artifacts#index"

  devise_for :users, ActiveAdmin::Devise.config

  resources :artifacts

  get '/info/about', to: 'info#about', as: :info_about

  resources :searches, only: [] do
    collection do
      get :tags
      get :software
    end
  end

  ActiveAdmin.routes(self)
end
