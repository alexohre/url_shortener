Rails.application.routes.draw do
  
  namespace :account do
    get 'dashboard', to: 'dashboard#home'
  end

  namespace :admin do
    resource :site, only: [:new, :create, :edit, :update]
    get 'dashboard', to: 'dashboard#home'
    get 'users', to: 'dashboard#users'
    # mails
    get 'emails', to: 'email#sent'
    get 'email/new', to: 'email#new'
    # trade
    get 'trade/active', to: 'trade#active'
    get 'trade/inactive', to: 'trade#inactive'
    # deposit 
    get 'deposit/pending', to: 'deposit#pending'
    get 'deposit/approved', to: 'deposit#approved'
    get 'deposit/declined', to: 'deposit#declined'
    # withdrawals
    get 'withdrawal/pending', to: 'withdrawal#pending'
    get 'withdrawal/approved', to: 'withdrawal#approved'
    get 'withdrawal/declined', to: 'withdrawal#declined'
    # settings
    get 'settings/account', to: 'setting#account'
    get 'settings/site_details', to: 'setting#site_details'
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
