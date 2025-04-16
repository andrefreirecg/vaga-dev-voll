Rails.application.routes.draw do
  resources :users, only: [:create, :destroy]
  resources :conversations, only: [:create, :destroy, :show] do
    collection do
      get 'user/:id', to: 'conversations#by_user'
    end
  end
  post '/login', to: 'session#login'
  post '/logout', to: 'session#logout'

end
