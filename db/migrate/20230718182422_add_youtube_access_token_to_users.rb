class AddYoutubeAccessTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :youtube_access_token, :string
  end
end
