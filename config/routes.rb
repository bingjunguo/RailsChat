Rails.application.routes.draw do
  resources :applies
  resources :friendships

  resources :users do
    collection do
      get :index_json
      get :index_new_friends_json
    end
  end
  resources :salaries
  resources :performances
  resources :announcements
  resources :materials
  resources :articles
  resources :departments
  resources :companynews
  resources :vacation

  resources :messages do
    collection do
      delete :destroyall
    end
  end

  resources :chats do
    member do
      patch :trans_auth
      post :add_user
      delete :delete_user
    end
  end

  root 'homes#home'

  get 'sessions/login' => 'sessions#new'
  post 'sessions/login' => 'sessions#create'
  delete 'sessions/logout' => 'sessions#destroy'

end
