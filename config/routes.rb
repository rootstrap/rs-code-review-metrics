require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'dashboard#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/sidekiq'
  post '/github_event_handler', to: 'webhook#handle'
  resource :metrics do
    get 'review_turnaround', to: 'metrics#review_turnaround'
  end
end
