Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'home', controller: 'videos', action: 'index'

  root to: 'sessions#index'

  get 'login', to: 'sessions#new'
  get 'register', to: 'users#new'

  resources :videos, only: [:show] do
    collection do 
      get "search", to: "videos#search"
    end
  end
  
  resources :categories, only: [:show]
  resources :sessions, only: [:create]
  resources :users, only: [:new, :create]
 
end
