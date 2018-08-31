Rails.application.routes.draw do
  get    '/profile', to: 'users#index'
  get   '/profile',  to: 'users#edit'
  get    '/signin',  to: 'users#show'
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  patch    '/profile/:id', to: 'users#update', as: 'patch_profile'
  put    '/profile/:id', to: 'users#update', as: 'put_profile'
  delete    '/profile/:id', to: 'users#destroy', as: 'delete_user'
  match ':controller(/:action(/:id))', :via => :get

  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
