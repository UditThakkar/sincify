Rails.application.routes.draw do
  root 'home#index'


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
