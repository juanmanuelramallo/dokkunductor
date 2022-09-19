Rails.application.routes.draw do
  namespace :dokku do
    resources :apps do
      resources :logs, only: :index
    end
  end

  root "dokku/apps#index"
end
