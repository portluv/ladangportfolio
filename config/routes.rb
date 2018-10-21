Rails.application.routes.draw do
  
  get '/create/uploadBook'
  post '/create/addBook'
  post '/create/convert'
  get    '/create', to: 'create#index'
  get    '/profile', to: 'users#index'
  post '/profile/update', to: 'users#createProfile'
  put '/profile/update/:id', to: 'users#updateProfile', as: 'put_profile'
  patch '/profile/update/:id', to: 'users#updateProfile', as: 'patch_profile'
  get   '/signin',  to: 'users#signIn'
  post  '/signin',  to: 'users#createSession', params: { session: { username: "", password: "" } }
  get   '/signout',  to: 'users#destroySession'
  get   '/signup',  to: 'users#signUp'
  post  '/signup',  to: 'users#createUser'
  put   '/account/update/:id', to: 'users#updateUser', as: 'put_user'
  patch   '/account/update/:id', to: 'users#updateUser', as: 'patch_user'
  delete    '/account/delete/:id', to: 'users#destroyUser', as: 'delete_user'
  match ':controller(/:action(/:id))', :via => :get

  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
