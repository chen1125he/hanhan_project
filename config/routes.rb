Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'home', :to => 'home#index'
  get '/', :to => 'home#index'
  get 'search', :to => "home#search"
  post 'search', :to => "home#search"
  resources :registers

  resources :discovers

  get '/posts/:id/comments/new', :to => 'comments#new'
  post '/posts/:id/comments', :to => 'comments#create'
  resources :posts do
    collection do
      match :say_good, :via => [:post]
      match :cancel_say_good, :via => [:post]
    end

    resources :comments do
    end
  end

  resources :my_posts do
  end

  resources :plates do
    collection do
      match :care_plate, :via => [:post]
      match :cancel_care_plate, :via => [:post]
    end
  end

  resources :my_cares

  resources :my_careds

  resources :my_comments

  resources :his_posts
  resources :his_comments

  get 'users/edit', :to => 'users#edit'
  get 'users/update', :to => 'users#update'
  resources :users

  resources :care_careds

  delete 'user_sessions/destroy', :to => 'user_sessions#destroy'
  resources :user_sessions

  get 'user_infos/edit', :to => 'user_infos#edit'
  # get 'user_infos/:key/destroy_user_image', :to => 'user_infos#destroy_user_image'
  resources :user_infos do
    match 'destroy_user_image', :via => [:post]
  end

  get 'admin', :to => "admin/posts#index"
  namespace :admin do

    resources :comments do
      collection do
        match :search, :via => [:post, :get]
      end
    end


    resources :users

    delete 'user_sessions/destroy', :to => 'user_sessions#destroy'
    resources :user_sessions do
    end

    resources :posts do
      collection do
        match :search, :via => [:post, :get]
      end
    end

    resources :plates

    resources :notices


  end
end
