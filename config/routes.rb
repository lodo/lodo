Lodo::Application.routes.draw do |map|

  devise_for :admins
  devise_for :users

  # Sample resource route within a namespace:

  map.namespace :admin do |admin|
    admin.resources :companies
    admin.resources :users
    admin.resources :admins
  end

  map.resources :units
  map.resources :projects
  map.resources :vat_accounts
  map.resources :bills
  map.resources :bill_items
  map.resources :orders
  map.resources :order_items
  map.resources :products
  map.resources :journal_operations
  map.resources :journals
  map.resources :periods, :collection => { :elevate_status => :post }
  map.resources :accounts do |account|
    account.resources :ledgers
  end
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Fixme: These can probably safely be removed. Once migration is done, try it out.
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'


end
