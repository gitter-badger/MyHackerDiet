Mhd::Application.routes.draw do
  resources :public
  devise_for :users

  #resources :sessions
  resources :weights
  resources :steps
  resources :withings_log
  resource :withings do
    get 'import'
  end

  match 'import_weight_csv', '/importWeight', :controller => 'weights', :action => 'csv_import'
  match 'import_steps_csv'  '/importStep', :controller => 'steps', :action => 'csv_import'
  match 'withings' '/withings', :controller => 'withings', :action => 'log'
  match 'withings_import' '/withings/import', :controller => 'withings', :action => 'import'

  match 'weight_graphs' '/weight_graphs', :controller => 'weights', :action => 'weight_graphs'

  get 'static/home'
  get 'static/about'

  root :to => "static#home"
end
