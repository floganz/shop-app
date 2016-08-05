Rails.application.routes.draw do
  devise_for :users

  root to: 'products#index'

  get 'search', to: 'products#search'
  get '/payments/new', to: 'payments#new'
  get '/payments/execute', to: 'payments#execute'

  resources :users, :products, :orders, :order_items


end
