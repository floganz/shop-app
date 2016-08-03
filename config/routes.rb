Rails.application.routes.draw do
  devise_for :users

  root to: 'products#index'

  get 'search', to: 'products#search'

  resources :users, :products, :orders, :order_items


end
