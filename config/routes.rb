Rails.application.routes.draw do
  root 'index#index'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :followings, only: [:index] do
    collection do
      delete 'destroy_multiple'
    end
  end
end
