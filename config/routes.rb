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
      get 'projects'
      get 'departments'
      get 'users'
      namespace :code_climate do
        resources :departments, only: :show, param: :department_name
      end
    end
  end
  get '/development_metrics', to: 'development_metrics#index'
  get 'tech_blog', to: 'tech_blog#index'
  get 'users/:id/projects', to: 'users/projects#index'
  get 'open_source', to: 'open_source#index'
end
