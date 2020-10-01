Rails.application.routes.draw do
# Sessions
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

# Users
  namespace :admin do
    # get 'users/index,show,new,create,edit,update,destroy'
    resources :users
  end

# Task
# root - :3000/
  root to: 'tasks#index'
  resources :tasks do
    post :confirm, action: :confirm_new, on: :new
    post :import, on: :collection
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
