Lodo::Application.routes.draw do |map|
  resources :paycheck_lines
  resources :paychecks
  
  resources :paycheck_templates 
  
  resources :paycheck_periods
  
  resources :paycheck_line_templates

  devise_for :admins
  devise_for :users

  # Sample resource route within a namespace:

  namespace :admin do
    resources :companies
    resources :users
    resources :admins
    resources :tax_zone_taxes
    resources :county_tax_zones
    resources :counties
    resources :tax_zones
  end

  resources :units
  resources :projects
  resources :vat_accounts
  resources :bills
  resources :bill_items
  resources :orders
  resources :order_items
  resources :products
  resources :journal_operations
  resources :journals
  resources :periods do
    member do
      post :elevate_status
    end
  end
  resources :accounts do
    resources :ledgers
  end

  match 'welcome/current_company' => 'welcome#current_company', :as => :change_company
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # Default routes
  match ':controller(/:action(/:id(.:format)))'

end

