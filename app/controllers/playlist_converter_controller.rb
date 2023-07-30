require 'google/apis/youtube_v3'
require 'googleauth'
require 'googleauth/web_user_authorizer'

class PlaylistConverterController < ApplicationController
  def convert
    url = params[:url]
    @name = params[:playlist_name]
    debugger
    spotify_user = RSpotify::User.find(current_user.spotify_user.creds['id'])
    spotify_user_id = spotify_user.href.match(%r{/users/([^/]+)})[1]
    playlist_id = url.match(%r{playlist/([\w\d]+)})[1]
    @playlist = RSpotify::Playlist.find_by_id(playlist_id)
    songs = @playlist.tracks.first(30)
    @song_names = songs.map { |song| song.name }
    access_token = current_user.youtube_user.credentials['access_token']
    playlist_id = create_youtube_playlist(access_token, @name)

    @song_names.each do |name|
      video_id = search_song_on_youtube(access_token, name)
      add_song_to_playlist(access_token, video_id, playlist_id)
    end

    @playlist_link =  "https://www.youtube.com/playlist?list=#{playlist_id}"
    puts '********************************'
    puts '********************************'
    puts @playlist_link
    puts '********************************'
    puts '********************************'
    render 'convert'
  end

  private

  def create_youtube_playlist(access_token, title)
    client = Google::Apis::YoutubeV3::YouTubeService.new
    client.authorization = Signet::OAuth2::Client.new(access_token: access_token)
    client.authorization.access_token = access_token
    playlist = Google::Apis::YoutubeV3::Playlist.new(
      snippet: Google::Apis::YoutubeV3::PlaylistSnippet.new(title: title),
      status: Google::Apis::YoutubeV3::PlaylistStatus.new(privacy_status: 'public')
    )
    response = client.insert_playlist('snippet,status', playlist)
    response.id
  end

  def search_song_on_youtube(access_token, song_name)
    client = Google::Apis::YoutubeV3::YouTubeService.new
    client.authorization = Signet::OAuth2::Client.new(access_token: access_token)
    client.authorization.access_token = access_token

    search_response = client.list_searches('snippet', q: song_name, type: 'video', max_results: 1)

    search_response.items.first.id.video_id
  end

  def add_song_to_playlist(access_token, video_id, playlist_id)
    client = Google::Apis::YoutubeV3::YouTubeService.new
    client.authorization = Signet::OAuth2::Client.new(access_token: access_token)
    client.authorization.access_token = access_token

    playlist_item = Google::Apis::YoutubeV3::PlaylistItem.new(
      snippet: {
        playlist_id: playlist_id,
        resource_id: {
          kind: 'youtube#video',
          video_id: video_id
        }
      }
    )

    client.insert_playlist_item('snippet', playlist_item)
  end
end
