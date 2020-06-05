require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  root to: 'users_projects#metrics'
  devise_for :admin_users, ActiveAdmin::Devise.config
  authenticate :admin_user do
    ExceptionHunter.routes(self)
  end
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/sidekiq'
  post '/github_event_handler', to: 'webhook#handle'
  resources :users_projects, only: [] do
    collection do
      get :metrics
    end
  end
  resources :projects, only: [] do
    collection do
      get :metrics
    end
  end
  get 'tech_blog', to: 'tech_blog#index'
end
