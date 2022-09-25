Rails.application.routes.draw do
  resource :ssh_key, only: [:new, :create, :show, :destroy]
  namespace :dokku do
    resources :apps do
      resources :logs, only: :index
    end
  end

  root "dokku/apps#index"
end
