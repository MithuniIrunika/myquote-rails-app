Rails.application.routes.draw do
  get "home/index"
  get "home/aindex"
  get "home/uindex"
  get "home/uquotes"
  get "home/about"
  get "home/search"
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  resources :users
  resources :philosophers
  resources :categories
  resources :quotes

  get  'login',  to: 'sessions#new'
  post 'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get '/admin',       to: 'home#aindex',  as: :admin
  get '/userhome',    to: 'home#uindex',  as: :userhome
  get '/your-quotes', to: 'home#uquotes', as: :your_quotes
  get '/about',       to: 'home#about',   as: :about
  get '/search',      to: 'home#search',  as: :search

  root "home#index"
end