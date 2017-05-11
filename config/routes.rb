Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'home', :to => 'home#index'
  get '/', :to => 'home#index'
  resources :registers

  get '/posts/:id/comments/new', :to => 'comments#new'
  post '/posts/:id/comments', :to => 'comments#create'
  resources :posts do
    resources :comments do
    end
  end

  resources :user_sessions


  namespace :admin do
    resources :users

    delete 'user_sessions/destroy', :to => 'user_sessions#destroy'
    resources :user_sessions do
    end

    resources :posts

    resources :plates


  end
end
