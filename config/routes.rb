require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'admin/events#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  authenticate :admin_user do
    ExceptionHunter.routes(self)
  end
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/sidekiq'
  post '/github_event_handler', to: 'webhook#handle'
  resources :projects, only: [] do
    resource :metrics, only: [] do
      get 'user_project_metric', controller: :projects
    end
  end
end
