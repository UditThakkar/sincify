class CreateYoutubeUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :youtube_users do |t|
      t.json :credentials
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
