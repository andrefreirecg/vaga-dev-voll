Rails.application.routes.draw do
  resources :users, only: [:create, :destroy]
  resources :conversations, only: [:create, :destroy, :show]
end
