Rails.application.routes.draw do
  
  resources :teams do 
    resources :roles 
  end
  resources :members, path: "/members/(:scope)", defaults: { scope: 1}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
