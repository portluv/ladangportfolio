Rails.application.routes.draw do
  resources :users
  # get 'home/index'
  match ':controller(/:action(/:id))', :via => :get

  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
