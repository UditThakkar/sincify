class SpotifySessionsController < ApplicationController
  def new
    redirect_to '/auth/spotify'
  end

  def callback
  end
end
