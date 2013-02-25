AssetManager::Application.routes.draw do
  devise_for :users

  # Restrict this.
  scope "/admin" do
    resources :users #, :only => [:index, :edit]
  end

  scope "/plum-landing" do
    root :to => redirect("/plum-landing/assets");
    resources :assets do
      collection do
        match 'type/:asset_type(/:layout)' => 'assets#type', :as => :type
        match 'keyword/:keyword(/:layout)' => 'assets#keyword', :as => :keyword
      end
      get :autocomplete_tag_name, :on => :collection
      get 'download'
    end

    resources :episodes do 
      resources :scenes
    end
  end


  # resources :assets do
  #   collection do
  #     post 'batch'
  #   end
  # end
  resources :versions

  resources :reels do
    match ':asset_id' => 'reel_assets#add', :constraints => { :asset_id => /\d+/ }, :via => [:post, :get], :as => :asset
    match ':asset_id' => 'reel_assets#remove', :constraints => { :asset_id => /\d+/ }, :via => [:delete], :as => :asset
    member do
      post 'sort'
      get 'close'
      get 'open'
    end
  end

  get "home/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => redirect("/plum-landing/assets")

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
