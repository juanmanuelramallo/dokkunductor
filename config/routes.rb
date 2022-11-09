Rails.application.routes.draw do
  resource :ssh_key, only: [:new, :create, :show, :destroy]
  namespace :dokku do
    resources :apps do
      resources :app_logs, only: :index
      resource :app_configs, only: :show
    end
    resources :postgres, param: :service do
      resource :postgres_links, only: [:new, :create, :destroy], as: :links
    end
  end

  root "dokku/apps#index"
end
