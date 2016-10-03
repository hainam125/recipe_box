Rails.application.routes.draw do
  devise_for :users
  root to: 'recipes#index'
  
  resources :recipes do
	resources :votes
  end
  resources :users, except: :create
  match "*path", to: redirect("/"), via: [:get,:post]
end
