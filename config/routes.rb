require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  root to: 'development_metrics#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  authenticate :admin_user do
    ExceptionHunter.routes(self)
  end
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/sidekiq'
  post '/github_event_handler', to: 'webhook#handle'
  resources :development_metrics, only: [] do
    collection do
      get 'project'
      get 'department'
    end
  end
  get '/development_metrics', to: 'development_metrics#index'
  get 'tech_blog', to: 'tech_blog#index'
end
