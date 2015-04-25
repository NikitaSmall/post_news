PostNews::Application.routes.draw do
  get '/users' => 'user#index', as: 'users'
  get '/users/show/:id' => 'user#view', as: 'user'

  patch '/users/to_corrector/:id' => 'user#to_corrector', as: 'to_corrector'
  patch '/users/to_author/:id' => 'user#to_author', as: 'to_author'
  patch '/users/to_editor/:id' => 'user#to_editor', as: 'to_editor'
  patch '/users/to_admin/:id' => 'user#to_admin', as: 'to_admin'

  resources :posts
  patch '/switch/:first/:second' => 'posts#switch', as: 'switch'
  patch '/switch/next/:first' => 'posts#switch_with_next', as: 'switch_with_next'
  patch '/switch/prev/:first' => 'posts#switch_with_prev', as: 'switch_with_prev'

  patch '/feature/:id' => 'posts#feature', as: 'feature'
  patch '/defeature/:id' => 'posts#defeature', as: 'defeature'

  devise_for :users
  mount Ckeditor::Engine => '/ckeditor'

  root 'newspaper#index'
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
