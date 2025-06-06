Rails.application.routes.draw do
  # Users
  resources :users, only: [:create, :destroy]

  # Auth
  post '/login', to: 'session#login'
  get '/me', to: 'session#me'
  post '/logout', to: 'session#logout'

  # Conversations
  resources :conversations, only: [:create, :destroy, :show] do
    collection do
      get 'user/:id', to: 'conversations#by_user'
    end
  end

  # Messages
  post '/messages', to: 'messages#create'

end
