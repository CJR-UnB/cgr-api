Rails.application.routes.draw do
  resources :teams, shallow: true do 
    resources :roles 
  end
  resources :users
  resources :members, except: [:delete]

  delete '/members/:id/:hard_delete', 
      to: 'members#destroy',
      defaults: {hard_delete: nil}
    
  post 'authenticate', to: 'authentication#authenticate'
 end
