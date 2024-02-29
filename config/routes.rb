Rails.application.routes.draw do
  
  namespace :account do
    get 'dashboard', to: 'dashboard#home'
    # setting
    get 'settings/change_password', to: 'setting#change_password'
    get 'settings/profile', to: 'setting#profile'
    # Trade
    get 'trades/new_trade', to: 'trades#new_trade'
    get 'trades/trade_history', to: 'trades#trade_history'
    post 'trades/:id/cancel', to: 'trades#cancel', as: 'cancel_trade'
    resources :trades

    # deposit
    get 'deposits/deposit', to: 'deposits#deposit'
    get 'deposits/deposit_history', to: 'deposits#deposit_history'
    resource :deposits, only: [:create]

    # withdrawals
    get 'withdrawals/withdraw', to: 'withdrawals#withdraw'
    get 'withdrawals/withdraw_history', to: 'withdrawals#withdraw_history'
    resource :withdrawals, only: [:create]
  end


  namespace :admin do
    resources :payment_methods, only: [:create, :destroy]

    resources :currency_pairs, only: [:create, :destroy] do
      collection do
        post :import_csv
      end
    end

    resource :site, only: [:new, :create, :edit, :update]
    get 'dashboard', to: 'dashboard#home'
    get 'users', to: 'dashboard#users'
    get 'users/:id', to: 'dashboard#show'
    # delete account
    delete 'users/:id', to: 'dashboard#destroy'
    # mails
    get 'emails', to: 'email#sent'
    get 'email/new', to: 'email#new'
    post 'emails', to: 'email#create'
    # trade
    get 'trade/active', to: 'trade#active'
    get 'trade/inactive', to: 'trade#inactive'
    delete 'trade/:id', to: 'trade#destroy'
    # deposit 
    get 'deposit/pending', to: 'deposit#pending'
    get 'deposit/approved', to: 'deposit#approved'
    get 'deposit/declined', to: 'deposit#declined'
    post 'deposit/approve/:id', to: 'deposit#approve', as: 'deposit_approve'
    post 'deposit/decline/:id', to: 'deposit#decline', as: 'deposit_decline'
    resources :deposit, only: [:show]
 
    # withdrawals
    get 'withdrawal/pending', to: 'withdrawal#pending'
    get 'withdrawal/approved', to: 'withdrawal#approved'
    get 'withdrawal/declined', to: 'withdrawal#declined'
    post 'withdrawal/approve/:id', to: 'withdrawal#approve', as: 'withdrawal_approve'
    post 'withdrawal/decline/:id', to: 'withdrawal#decline', as: 'withdrawal_decline'
    resources :withdrawal, only: [:show]

    # settings
    get 'settings/account', to: 'setting#account'
    get 'settings/site_details', to: 'setting#site_details'
    get 'settings/currency_pairs', to: 'setting#currency_pairs'
    get 'settings/payment_method', to: 'setting#payment_methods'

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
end
