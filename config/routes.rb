Rails.application.routes.draw do
  resource :ssh_key, only: [:new, :create, :show, :destroy]
  namespace :dokku do
    resources :apps do
      resources :app_logs, only: :index
      resource :app_configs, only: [:show, :update]
    end
    resources :postgres, param: :service do
      resource :postgres_links, only: [:new, :create, :destroy], as: :links
    end
    resources :redis_services, param: :name do
      resource :redis_links, only: [:new, :create, :destroy], as: :links
    end
    resources :ssh_keys, only: [:index, :create]
  end

  root "dokku/apps#index"
end
