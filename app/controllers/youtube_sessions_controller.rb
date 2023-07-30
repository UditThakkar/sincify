require 'google/api_client/client_secrets'

class YoutubeSessionsController < ApplicationController
  include Devise::Controllers::Helpers

  def new
    redirect_to auth_client.authorization_uri.to_s, allow_other_host: true
  end

  def callback
    auth_client.code = params[:code]
    auth_client.fetch_access_token!
    auth_client.client_secret = nil
    
    # Save the access token in the session or user record.
    access_token = auth_client.access_token
    # session[:youtube_access_token] = access_token

    # YoutubeSession.create!(
    #   credentials: JSON.parse(auth_client.to_json)
    # )
    current_user.build_youtube_user(credentials: JSON.parse(auth_client.to_json)).save
    redirect_to '/'
  end

  def auth_client
    @_auth_client ||= begin
      client_secrets = Google::APIClient::ClientSecrets.new(
        {
          "web": {
            "client_id": Rails.application.credentials.dig(:youtube, :client_id),
            "project_id": "sonic-proxy-331506",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            "client_secret": Rails.application.credentials.dig(:youtube, :client_secret),
            "redirect_uris": [
              redirect_uri
            ]
          }
        }
      )
      auth_client = client_secrets.to_authorization
      auth_client.update!(
        scope: 'https://www.googleapis.com/auth/youtube.force-ssl',
        redirect_uri: redirect_uri, # Use Devise's callback path
        additional_parameters: {
          access_type: 'offline',
          include_granted_scopes: true,
        }
      )
      auth_client
    end
  end

  def refresh_token
    if current_user && current_user.youtube_user.credentials['refresh_token']
      refresh_token = current_user.youtube_user.credentials['refresh_token']

      auth_client.refresh_token = refresh_token

      if auth_client.fetch_access_token!
        new_access_token = auth_client.access_token

        debugger
        current_user.youtube_user.credentials['access_token'] = new_access_token
        current_user.youtube_user.save!

        redirect_to '/'
      else
        flash[:alert] = 'Failed to refresh the access token.'
        redirect_to '/youtube_sessions/new'
      end
    else
      flash[:alert] = 'User refresh token not found.'
      redirect_to '/youtube_sessions/new'
    end
  end

  def redirect_uri
    'http://localhost:3000/youtube_sessions/callback'
  end
end
