FxStar::Application.routes.draw do
  root 'sessions#index'
  get  '/login'  => 'sessions#login_page', as: :login
  post '/login'  => 'sessions#login'
  get  '/logout' => 'sessions#logout', as: :logout

  get  '/followers/:id/index' => 'followers#index', as: :followers_index
  get  '/followers/signup' => 'followers#new', as: :followers_new
  get  '/followers/best_traders' => 'followers#best_traders', as: :followers_best_traders
  post '/followers/create' => 'followers#create', as: :followers_create
  get  '/followers/:id/settings' => 'followers#settings', as: :followers_settings_page
  post '/followers/:id/modify_password' => 'followers#modify_password', as: :followers_modify_password
  post '/followers/:id/bind_account' => 'followers#bind_account', as: :followers_bind_account
  get  '/followers/:id/followship' => 'followers#followship', as: :followers_followship
  get  '/followers/:id/history' => 'followers#history', as: :followers_history
  get  '/followers/:id/register_trade_account' => 'followers#register_trade_account', as: :followers_register_trade_account_page
  post '/followers/:id/create_trade_account' => 'followers#create_trade_account', as: :followers_create_trade_account

  get  '/traders/:id/index' => 'traders#index', as: :traders_index
  get  '/traders/signup' => 'traders#new', as: :traders_new
  post '/traders/create' => 'traders#create', as: :traders_create
  get  '/traders/:id/settings' => 'traders#settings', as: :traders_settings_page
  post '/traders/:id/modify_password' => 'traders#modify_password', as: :traders_modify_password
  post '/traders/:id/bind_account' => 'traders#bind_account', as: :traders_bind_account

  #for follower
  post '/followers/:id/view_traders/:trader_id/create_followship' => 'followships#create', as: :followships_create

  #for trader
  get  '/followers/:id/view_traders/:trader_id' => 'traders#show_for_follower', as: :traders_show_for_follower

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
