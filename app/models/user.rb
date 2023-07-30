class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :spotify_user
  has_one :youtube_user

  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
  end
end
