Rails.application.routes.draw do
  resource :ssh_key, only: [:new, :create, :show, :destroy]
  namespace :dokku do
    resources :apps do
      resources :logs, only: :index
    end
    resources :postgres, param: :service
  end

  root "dokku/apps#index"
end
