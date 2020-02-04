Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    
    # トップページのルーティング
    root to: 'toppages#index'
    
    # ログイン用ルーティング
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    # ユーザ登録用ルーティング
    get 'signup', to: 'users#new'
    
    
    resources :users, only: [:index, :show, :new, :create]
    
    resources :microposts, only: [:create, :destroy]
end
