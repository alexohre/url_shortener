Rails.application.routes.draw do
  get 'links/redirect/:short_code', to: 'links#redirect', as: :links_redirect
  # constraints(domain: 'bit.sh') do
  #   get '/:short_code', to: 'urls#redirect', as: :bit_redirect
  # end
  
  get '/:short_code', to: 'urls#redirect'
  # Define the route for redirecting from url.softalx.com to shorturl.softalx.com
  constraints(host: 'url.softalx.com') do
    get '/', to: redirect('https://shorturl.softalx.com')  # Redirect root path

    get '/:short_code', to: 'urls#redirect'  # Handle shortened URLs
  end
  
  namespace :account do
    resource :subscription, only: [ :update]
    get 'dashboard', to: 'dashboard#home'
    get 'dashboard/subscription', to: 'dashboard#subscription'
    post 'revert_masquerade', to: "dashboard#revert_masquerade"
    # setting
    get 'settings/change_password', to: 'setting#change_password'
    get 'settings/profile', to: 'setting#profile'

    resources :urls, param: :short_code
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

  post '/fetch_title', to: 'title_fetcher#fetch_title'
end
