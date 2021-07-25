Rails.application.routes.draw do
  root to: 'boards#index'
  get '/boards/new', to: 'boards#new', as: 'new_board'
  get '/boards/:id/edit', to: 'boards#edit', as: 'edit_board'
  get '/boards', to: 'boards#index'
  get '/boards/:id', to: 'boards#show', as: 'board'
  post '/update', to: 'boards#update'
  post '/boards', to: 'boards#create'
  patch '/boards/:id', to: 'boards#update'
  put '/boards/:id', to: 'boards#update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
