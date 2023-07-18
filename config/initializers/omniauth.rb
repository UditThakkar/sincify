Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.credentials.dig(:youtube, :client_id), Rails.application.credentials.dig(:youtube, :client_secret), scope: 'https://www.googleapis.com/auth/youtube.force-ssl'
end
