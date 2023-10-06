Rails.application.routes.draw do

  namespace :account do

  end

  namespace :admin do

  end

  devise_for :accounts, controllers: {
    sessions: 'accounts/sessions',
    registrations: 'accounts/registrations',
    passwords: 'accounts/passwords',
    confirmations: 'accounts/confirmations'
    }, path: 'auth', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'secret',
    registration: 'account',
    sign_up: 'sign_up'
  }

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    }, path: 'admin', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'secret',
    confirmation: 'verification',
    unlock: 'unblock',
    registration: 'user',
    sign_up: 'sign_up'
  }

  root 'pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
