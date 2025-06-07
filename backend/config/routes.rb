Rails.application.routes.draw do
  # Auth
  post '/login', to: 'session#login'
  get '/me', to: 'session#me'
  post '/logout', to: 'session#logout'

  # Users
  resources :users, only: [:create, :destroy, :show] do
    collection do
      get 'all', to: 'users#get_all'
    end
  end


  # Conversations
  resources :conversations, only: [:create, :destroy, :show] do
    collection do
      get 'user/:id', to: 'conversations#by_user'
    end
  end

  # Messages
  post '/messages', to: 'messages#create'
  get 'messages/conversation/:conversation_id', to: 'messages#get_messages_paginated'
  delete '/messages/:id', to: 'messages#delete'

end
