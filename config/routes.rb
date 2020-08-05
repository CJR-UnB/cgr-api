Rails.application.routes.draw do
  resources :roles
  resources :teams
  resources :members
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
