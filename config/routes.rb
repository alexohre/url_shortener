Rails.application.routes.draw do
  # constraints(domain: 'bit.sh') do
  #   get '/:short_code', to: 'urls#redirect', as: :bit_redirect
  # end
  
  get '/:short_code', to: 'urls#redirect'
  # Define the route for redirecting from url.softalx.com to shorturl.softalx.com
  constraints(host: 'url.softalx.com', path: '') do
    redirect_to 'https://shorturl.softalx.com', allow_other_host: true
  end

  # Route for redirecting short codes to the corresponding URLs
  get '/:short_code', to: 'urls#redirect', constraints: { host: 'url.softalx.com' }
  
  namespace :account do
    get 'dashboard', to: 'dashboard#home'
    post 'revert_masquerade', to: "dashboard#revert_masquerade"
    # setting
    get 'settings/change_password', to: 'setting#change_password'
    get 'settings/profile', to: 'setting#profile'

    resources :urls, param: :short_code
    # get '/:short_code', to: redirect('/%{short_code}')
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
    post 'masquerade_as_account', to: 'dashboard#masquerade_as_account'
    # delete account
    delete 'users/:id', to: 'dashboard#destroy'
    # mails
    get 'emails', to: 'email#sent'
    get 'email/new', to: 'email#new'
    post 'emails', to: 'email#create'
        # settings
    get 'settings/account', to: 'setting#account'
    get 'settings/password', to: 'setting#admin_password'
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
