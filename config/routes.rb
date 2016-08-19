Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root to: 'products#index'

  get 'search', to: 'products#search'
  get '/payments/new', to: 'payments#new'
  get '/payments/execute', to: 'payments#execute'
  get '/users/get_email', to: 'users#get_email'
  get '/products/autocomplete', to: 'products#autocomplete'
  get '/products/result', to: 'products#result'
  get '/products/get_data', to: 'products#get_data'

  resources :users, :products, :orders, :order_items
end
