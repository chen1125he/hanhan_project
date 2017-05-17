Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'home', :to => 'home#index'
  get '/', :to => 'home#index'
  resources :registers

  get '/posts/:id/comments/new', :to => 'comments#new'
  post '/posts/:id/comments', :to => 'comments#create'
  resources :posts do
    collection do
      match :say_good, :via => [:post]
    end

    resources :comments do
    end
  end

  resources :my_posts do
  end

  resources :care_careds

  delete 'user_sessions/destroy', :to => 'user_sessions#destroy'
  resources :user_sessions

  get 'user_infos/edit', :to => 'user_infos#edit'
  # get 'user_infos/:key/destroy_user_image', :to => 'user_infos#destroy_user_image'
  resources :user_infos do
    match 'destroy_user_image', :via => [:post]
  end


  namespace :admin do
    resources :users

    delete 'user_sessions/destroy', :to => 'user_sessions#destroy'
    resources :user_sessions do
    end

    resources :posts

    resources :plates

    resources :notices


  end
end
