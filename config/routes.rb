Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  # get '/spotify_sessions', to: 'spotify_sessions#new'
  # get '/spotify_sessions/callback', to: 'spotify_sessions#callback'
  get '/auth/spotify/callback', to: 'users#spotify'

  get '/youtube_sessions', to: 'youtube_sessions#new'
  get '/youtube_sessions/callback', to: 'youtube_sessions#callback'
  get '/refresh_token', to: 'youtube_sessions#refresh_token'

  resources :playlist_converter, only: [] do
    collection do
      get :convert
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
