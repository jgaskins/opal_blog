Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :articles

      namespace :store do
        resources :categories
      end

      resource  :session
    end
  end

  root to: 'home#index'
  get '*all', to: 'home#index'
end
