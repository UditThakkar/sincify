Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root 'home#index'

  # devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :converter, only: [] do
    collection do
      get :convert_playlist
    end
  end

  get '/youtube_sessions', to: 'youtube_sessions#new'
  get '/youtube_sessions/callback', to: 'youtube_sessions#callback'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
