require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  root to: 'development_metrics#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  # TODO: Remove or update ExceptionHunter
  # authenticate :admin_user do
  #   ExceptionHunter.routes(self)
  # end
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/sidekiq'
  post '/github_event_handler', to: 'webhook#handle'
  resources :development_metrics, only: [] do
    collection do
      resources :departments, only: [], param: :name do
        resources :time_to_merge_prs, only: :index, module: :pull_requests
        resources :time_to_second_review_prs, only: :index, module: :pull_requests
      end
      resources :repositories, only: [], param: :name do
        resources :time_to_merge_prs_repository, only: :index, module: :pull_requests
        resources :time_to_second_review_prs_repository, only: :index, module: :pull_requests
        resources :pull_request_size_prs_repository, only: :index, module: :pull_requests
        resources :review_coverage_prs_repository, only: :index, module: :pull_requests
      end
      resources :users, only: [] do
        resources :repositories, only: :index, controller: 'users/repositories'
      end

      get 'repositories'
      get 'departments'
      get 'users'
      namespace :code_climate do
        resources :departments, only: :show, param: :department_name
      end
    end
  end
  resources :development_metrics, only: [] do
    get 'products', on: :collection
    get 'products_metrics', on: :collection
  end
  resources :departments, only: [], param: :name do
    namespace :repositories do
      resources :by_relevance, only: :index, param: :department_name
    end
  end
  resources :open_source, only: :index do
    collection do
      resources :users, only: [] do
        collection do
          resources :external_pull_requests, only: :index,
                                             controller: 'users/external_pull_requests'
        end
      end
    end
  end
  get '/development_metrics', to: 'development_metrics#index'
  get 'tech_blog', to: 'tech_blog#index'
  namespace :jira do
    resources :defect_escape_rate, only: :index
  end
end
