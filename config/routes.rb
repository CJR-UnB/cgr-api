Rails.application.routes.draw do
  
  resources :teams, shallow: true do 
    resources :roles 
  end
  resources :members
end
