BarterLi::Application.routes.draw do
  resources :locations

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root 'public#index'
  get '/index', to: 'public#index'
  get '/profile', to: 'users#edit_profile', as: 'edit_profile'
  patch '/profile', to: 'users#update_profile', as: 'update_profile'
  post '/register', to: 'public#register_email', as: 'register_email'
  get '/collaborate', to: 'public#collaborate', as: 'collaborate'
  get '/notifications', to: 'notifications#user_notifications', as: 'user_notifications'
  get '/search', to: 'search#search_books', as: 'search'
  get '/book_info', to: 'books#book_info'
  post '/wish_list', to: 'books#add_wish_list'
  get '/my_books', to: 'books#my_books', as: 'my_books'
  get '/book_suggestions', to: 'books#book_suggestions'
  post '/user_reviews', to: 'users#create_user_review', as: 'user_review'
  get '/join_group/:group_id', to: 'members#join_group'
  get '/my_library', to: 'users#my_library', as: 'my_library'
  get 'hangouts', to: 'locations#hangouts'
  
  devise_for :users, controllers: {omniauth_callbacks: "authentications"}
  resources :books 
  resources :tags
  resources :barters do
    resources :notifications
  end
  resources :groups do
    resources :posts
    member do
      get 'manage_members'
      get 'membership_approval'
      post 'assign_membership_status'
    end
  end 
  get '/api/v1/book_info', to: 'books#book_info'
  get '/api/v1/book_suggestions', to: 'books#book_suggestions'
  get '/api/v1/hangouts', to: 'locations#hangouts'
  
  namespace :api do
    namespace :v1, defaults:{format: 'json'} do
        post '/auth_token', to: 'authentications#get_auth_token'
        post '/create_user', to: 'authentications#create_user'
        get '/user_preferred_location', to: 'books#user_preferred_location'
        post '/user_preferred_location', to: 'books#set_user_preferred_location'
        get '/search', to: "search#search_books"
        post '/barter_notification', to: "barters#send_barter_notification"
        get '/user_profile', to: "users#user_profile"
        get '/current_user_profile', to: "users#show"
        patch '/user_update', to: "users#update"
        resources :books
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
