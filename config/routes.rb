require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'projects#user_project_metric'
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
  get 'tech_blog', to: 'tech_blog#index'
end
