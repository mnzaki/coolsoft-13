Sprint0::Application.routes.draw do

  match '/home/index' => 'home#index'
  default_url_options :host => 'localhost:3000'
  root :to => 'home#index'

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks',
                                       :registrations => 'registrations' }

  devise_scope :user do
    match 'users/registrations/twitter_screen_name_clash' => 'registrations#twitter_screen_name_clash'
  end

  resources :users do
    member do
      match 'ban_unban' => 'admins#ban_unban'
    end

    collection do
      put 'change_settings'
      match 'expertise'
      match 'new_committee_tag'
      match 'confirm_deactivate'
      match 'deactivate'
    end
  end

  resources :ideas do
    match 'filter', on: :collection
    member do
      match 'vote'
      match 'unvote'
      match 'archive'
      match 'unarchive'
      match 'add_prespectives' => 'committees#add_prespectives'
      match 'disapprove' => 'committees#disapprove'
      match 'add_rating'
    end
  end

  controller :home do
    match 'home/search'
    match 'home/searchelse'
    match 'home/index'
  end

  # Admin actions routes
  controller :admins do
    match 'admins/invite'
    match 'admins/invite_committee'
  end

  # Committe actions routes
  controller :committees do
    match 'review_ideas'
  end

  # Dashboard routes
  controller :dashboard do
    match 'dashboard/index'
    match 'dashboard/getallideas'
    match 'dashboard/gettags'
    match 'dashboard/getideas'
  end

  # Notifications routes
  controller :notifications do
    match 'notifications/view_all_notifications'
    match 'notifications/redirect_idea'
    match 'notifications/redirect_review'
    match 'notifications/redirect_expertise'
  end
  match 'notifications' => 'application#update_nav_bar'

  # Tag routes
  controller :tags do
    match 'tags/ajax'
  end

  controller :ratings do
    match 'ratings/ajax'
  end

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended
  # for RESTful applications.
  # Note: This route will make all actions in every controller
  # accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  match '/review_ideas' => 'committees#review_ideas'
  match '/users/confirm_deactivate' => 'users#confirm_deactivate'
  match '/users/deactivate' => 'users#deactivate'
end
