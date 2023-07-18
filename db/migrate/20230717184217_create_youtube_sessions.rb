class CreateYoutubeSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :youtube_sessions do |t|
      t.string :session_token, null: false
      t.json :credentials

      t.timestamps
    end
    add_index :youtube_sessions, :session_token
  end
end
