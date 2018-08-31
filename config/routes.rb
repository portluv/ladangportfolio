Rails.application.routes.draw do
  resource :users
  get    '/profile', to: 'users#index'
  get   '/profile/:id',  to: 'users#editProfile', as: 'edit_profile'
  get   '/signin',  to: 'users#signIn'
  post  '/signin',  to: 'users#createSession', params: { session: { username: "", password: "" } }
  get   '/signup',  to: 'users#signUp'
  post  '/signup',  to: 'users#createUser'
  patch '/profile/:id', to: 'users#updateProfile', as: 'patch_profile'
  put   '/profile/:id', to: 'users#updateProfile', as: 'put_profile'
  delete    '/profile/:id', to: 'users#destroyUser', as: 'delete_user'
  match ':controller(/:action(/:id))', :via => :get

  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
