PostNews::Application.routes.draw do
  root 'newspaper#index'

  get '/read/:id' => 'newspaper#read', as: 'read_post'
  post '/share/:id' => 'newspaper#share', as: 'share_post'
  get '/feed' => 'newspaper#feed', as: 'feed'

  get '/all' => 'newspaper#all', as: 'all_posts'
  get '/all_users' => 'newspaper#all_users', as: 'all_users'

  get '/users_admin' => 'user#index', as: 'users'
  get '/users/show/:id' => 'user#view', as: 'user'
  #devise_scope :user do
  #  get '/registration' => 'users/registrations#new'
  #end

  patch '/users/to_corrector/:id' => 'user#to_corrector', as: 'to_corrector'
  patch '/users/to_author/:id' => 'user#to_author', as: 'to_author'
  patch '/users/to_editor/:id' => 'user#to_editor', as: 'to_editor'
  patch '/users/to_admin/:id' => 'user#to_admin', as: 'to_admin'

  delete '/users_profile/:id' => 'user#destroy', as: 'delete_user'

  #ajax validations:
  post '/posts_check_title' => 'posts#check_title', as: 'check_title'
  post '/user_check_username' => 'user#check_username', as: 'check_username'
  post '/user_check_email' => 'user#check_email', as: 'check_email'
  # get '/check_recaptcha' => 'user#check_recaptcha'

  resources :posts#, except: 'feed'
  get '/admin' => 'posts#index'
  get '/posts/tag/:tag' => 'posts#index', as: 'tag_posts'
  get '/posts_main' => 'posts#main', as: 'main_posts'
  get '/posts_hidden' => 'posts#hidden', as: 'hidden_posts'
  get '/posts_own' => 'posts#my_posts', as: 'my_posts'
  # post '/posts/search' => 'posts#index', as: 'search'

  patch '/switch_to/:first/:second' => 'posts#switch', as: 'switch'
  patch '/switch/next/:first' => 'posts#switch_with_next', as: 'switch_with_next'
  patch '/switch/prev/:first' => 'posts#switch_with_prev', as: 'switch_with_prev'

  patch '/switch_main/next/:first' => 'posts#switch_with_next_main', as: 'switch_with_next_main'
  patch '/switch_main/prev/:first' => 'posts#switch_with_prev_main', as: 'switch_with_prev_main'

  patch '/feature/:id' => 'posts#feature', as: 'feature'
  patch '/defeature/:id' => 'posts#defeature', as: 'defeature'

  patch '/main/:id' => 'posts#to_main', as: 'to_main'
  patch '/hide/:id' => 'posts#hide', as: 'hide'

  # devise_for :users
  devise_for :users, controllers: { registrations: 'users/registrations' }
  mount Ckeditor::Engine => '/ckeditor'
  
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
