class UsersController < ApplicationController
  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    current_user.build_spotify_user(creds: spotify_user).save
    debugger
    redirect_to root_path
  end
end
