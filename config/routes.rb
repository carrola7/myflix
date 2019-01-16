Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'home', controller: 'videos', action: 'index'

  root to: 'sessions#index'

  get 'login', to: 'sessions#new'

  resources :videos, only: [:show] do
    collection do 
      get "search", to: "videos#search"
    end
  end
  
  resources :categories, only: [:show]
 
end
