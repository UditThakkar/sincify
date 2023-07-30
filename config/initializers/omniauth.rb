# config/initializers/omniauth.rb
require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, Rails.application.credentials.dig(:spotify, :client_id), Rails.application.credentials.dig(:spotify, :client_secret), scope: 'user-read-email playlist-modify-public user-library-read user-library-modify'
  provider :google_oauth2, Rails.application.credentials.dig(:youtube, :client_id), Rails.application.credentials.dig(:youtube, :client_secret), scope: 'https://www.googleapis.com/auth/youtube.force-ssl'

  OmniAuth.config.allowed_request_methods = [:post, :get]
end