Rails.application.routes.draw do

# Transaction POST routes
post "transaction/follow/:ticker" => "transaction#follow"
post "transaction/unfollow/:id" => "transaction#unfollow"
post "transaction/confirmation/:process" => "transaction#confirmation"

#Transaction GET routes
get "transaction/index"
get "transaction/search"
get "transaction/sell/:ticker" => "transaction#sell_stock"
get "transaction/purchase/:ticker" => "transaction#purchase_stock"

root "transaction#index"

# User POST routes
post "create/user" => "user#create_user"
post "user/login" => "user#login"
post "user/update" => "user#update"

#User GET routes
get "/logout" => "user#logout"
get "login" => "user#loginreg"
get "/account" => "user#account"


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
