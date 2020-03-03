Rails.application.routes.draw do
  
  post '/create/showBook/:id',  to: 'create#showBook', as: 'loadBookView'
  post '/create/addThing'
  post '/create/convert'
  get    '/create', to: 'create#index'
  get    '/connect', to: 'connection#index'
  get    '/connect/add/:id', to: 'connection#addFriend', as: 'addFriend'
  get    '/connect/remove/:id', to: 'connection#removeFriend', as: 'removeFriend'
  get    '/home', to: 'dashboard#home'
  get    '/profile/:id', to: 'users#index', as: 'viewProfile'
  get    '/profile', to: 'users#edit', as: 'editProfile'
  get    '/linkedIn/updateUser', to: 'users#updateUserSignInWithLinkedIn', as: 'updateUserSignInWithLinkedIn'
  get    '/github/updateUser', to: 'users#updateUserSignInWithGithub', as: 'updateUserSignInWithGithub'
  get    '/google/updateUser', to: 'users#updateUserSignInWithGoogle', as: 'updateUserSignInWithGoogle'
  post '/profile/create', to: 'users#createProfile', as: 'create_new_profile'
  put '/profile/update/:id', to: 'users#updateProfile', as: 'put_profile'
  patch '/profile/update/:id', to: 'users#updateProfile', as: 'patch_profile'
  get   '/dashboard',  to: 'dashboard#index'
  post   '/newstatus',  to: 'dashboard#newStatus'
  get   '/signin',  to: 'users#signIn'
  get   '/linkedIn/signin',  to: 'users#signInWithLinkedIn'
  get   '/github/signin',  to: 'users#signInWithGithub'
  get   '/google/signin',  to: 'users#signInWithGoogle'
  get   '/authLinkedIn',  to: 'users#linkedInAuthRedirect', as: 'auth_linked_in'
  get   '/authGithub',  to: 'users#githubAuthRedirect', as: 'auth_github'
  get   '/authGoogle',  to: 'users#googleAuthRedirect', as: 'auth_google'
  post  '/signin',  to: 'users#createSession', params: { session: { username: "", password: "" } }
  get   '/signout',  to: 'users#destroySession'
  get   '/signup',  to: 'users#signUp'
  post  '/signup',  to: 'users#createUser'
  put   '/account/update', to: 'users#updateUser', as: 'put_user'
  delete    '/account/delete/:id', to: 'users#destroyUser', as: 'delete_user'
  match ':controller(/:action(/:id))', :via => :get

  root 'dashboard#landingpage'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
