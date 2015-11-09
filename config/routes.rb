Rails.application.routes.draw do

  get 'static_pages/contacts'
  get 'static_pages/about_us'
  get 'static_pages/payments'

  get '3b5fe44d4592.html' => "files#show"

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['ADMIN_LOGIN'] && password == ENV['ADMIN_PASSWORD']
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"

  resources :orders do
    member do
      post :repeat
      post :cancel
    end
  end

  get 'orders_exchange/1с' => 'orders#exchange_1с'

  resources :line_items do
    collection do
      get :add_to_cart
    end
  end

  namespace :payments do
    post :result
    post :success
    post :cancel
  end
  resources :carts

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions", :passwords => "passwords"}

  get '/account' => 'users#show', as: 'account'

  scope module: 'admin', path: 'admin' do
    resources :producers
    resources :messages
    resources :characteristic_names
    resources :characteristic_values
    resources :characteristics_group_vls
    resources :characteristics_group_rows
    resources :characteristics_groups
    resources :product_characteristics
    resources :posts
    resources :stocks
    resources :parts
    resources :people
    resources :discounts
    resources :home_page_banners
  end

  namespace :admin do
    resource :dashboard
    resources :deals
    resources :tizers
    resources :banners
    resources :orders do
      member do
        post :cancel
        post :ship
      end
    end
    resources :users
    resources :projects
    resources :coupons
    resources :special_offers
    resources :imports do
      collection do
        patch :proccess
      end
    end
    resources :products do
      collection do
        post :sort
      end
    end
    resources :categories do
      post :sort, on: :collection
      resources :products do
        post :sort, on: :collection
      end
    end
    resources :pages do
      post :sort, on: :collection
    end
    root 'categories#index'
  end
  # mount Ckeditor::Engine => '/ckeditor'
  resources :pages
  resources :deals, only: [:show, :index]
  resources :products, only: [:show] do
    collection do
      post :sort, :import
      get :compare, :import, :parser
    end
    member do
      get :add_to_compare, :remove_from_compare
    end
  end

  get :search, to: 'categories#search', as: 'searches'
  get 'searches/show'

  get 'wishlist/index'
  post 'wishlist/add_to_wishlist/:id' => 'wishlist#add_to_wishlist', as: 'add_to_wishlist'
  delete 'wishlist/destroy/:id' => 'wishlist#destroy', as: 'destroy_from_wishlist'

  post 'coupons/check' => 'coupons#check', as: 'coupons_check'

  post 'messages/create' => 'messages#create', as: 'create_message_from_form'
  post 'calculate_shipping/calculate' => 'calculate_shipping#calculate', as: 'calculate_shipping'
  post 'calculate_shipping/select_price_of_shipping' => 'calculate_shipping#select_price_of_shipping', as: 'select_price_of_shipping'
  get 'posts/show/:id' => 'posts#show', as: 'posts_show'
  get 'posts/index' => 'posts#index', as: 'posts_index'
  resources :categories, only: [:show, :index] do
    resources :products, only: [:show]
  end
  root 'welcome#index'
end
