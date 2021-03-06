Rails.application.routes.draw do
  
  resources :carts

  resources :products do
    collection do
      match 'search' => 'products#search', via: [:get, :post], as: :search
    end
  end

  resources :registries do
    collection do
      match ':id/search' => 'registries#search', via: [:get, :post], as: :search
      match 'search_reg' => 'registries#search_reg', via: [:get, :post], as: :search_reg
    end
  end

  devise_for :admins
  devise_for :users, controllers: { registrations: "users/registrations" }
  root 'pages#index'
  get 'pages/about' => 'pages#about', as: :about
  post 'nonuser_checkout' => 'registries#nonuser_checkout', as: :nonuser_checkout
  post 'nonuser_checkout_confirmation' => 'registries#nonuser_checkout_confirmation', as: :nonuser_checkout_confirmation
  
  # Admin pages
  authenticated :user, lambda { |u| u.admin? } do
    get 'pages/all_users' => 'pages#all_users'
  end
  
  devise_scope :user do
    post 'users/invitation/new' => 'users/registrations#batch_invite'
  end
  
  authenticated :user do
    root :to => 'pages#index', as: :authenticated_root
    resources :users, only: [:update], :constraints => { :id => /[0-9]+/ }
    post 'set_current_reg' => 'products#set_current_reg'
    post 'add_product_to_registry' => 'registries#add_product_to_registry'
    post 'add_remove_product' => 'registries#add_remove_product'
    post 'new_payment_method' => 'payment_methods#save_payment_option'
    post 'add_to_cart' => 'carts#add_to_cart'
    post 'checkout' => 'carts#checkout'
    post 'checkout_confirmation' => 'carts#checkout_confirmation'
    post 'destroy_cart_offer' => 'carts#destroy_cart_offer'
    post 'add_remove_as_guest' => 'registries#add_remove_as_guest'
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
