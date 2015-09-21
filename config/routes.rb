Rails.application.routes.draw do
  mount Knock::Engine => "/api"

  put '/settings', to: 'settings#update', as: 'settings'
  get '/settings', to: 'settings#edit', as: 'edit_settings'

  get '/comments_script', to: 'application#comments_script', as: 'comments_script'

  resources :apps, only: [:show, :index]

  root to: "artifacts#index"

  devise_for :users, ActiveAdmin::Devise.config.merge(:path => 'users', controllers: {passwords: 'users/passwords', registrations: 'users/registrations', sessions: 'users/sessions'})
  get 'my_artifacts', to: 'users#show', as: :my_artifacts

  resources :artifacts
  get '/artifacts/:id/*filename', to: 'artifacts#download', as: :artifact_download, format: false

  get '/info/about', to: 'info#about', as: :info_about
  get '/info/contact', to: 'info#contact', as: :info_contact

  # For licenses api
  resources :licenses, only: [:index], defaults: { format: :json }

  resources :searches, only: [], defaults: { format: :json } do
    collection do
      get :tags
      get '/apps', action: :software
      get :file_formats
    end
  end

  ActiveAdmin.routes(self)
end
