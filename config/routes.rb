Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'home', controller: 'videos', action: 'index'

  root to: 'pages#front'

  get 'login', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  get 'my_queue', to: 'queue_items#index'

  resources :videos, only: [:show] do
    collection do 
      get "search", to: "videos#search"
    end

    resources :reviews, only: [:create]
    resources :queue_items, only: [:create]
  end
  
  resources :categories, only: [:show]
  resources :sessions, only: [:create]
  resources :users, only: [:new, :create, :show]
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]
  resources :reviews, only: [:create]
  resources :queue_items, only: [:create, :destroy] do
    collection do
      put 'update_all', to: 'queue_items#update_all'
    end
  end
 
end
