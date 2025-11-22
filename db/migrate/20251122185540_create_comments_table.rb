class CreateCommentsTable < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :video_transcription, null: false, foreign_key: true
      t.string :agent, null: false
      t.text :content
      t.timestamps
    end
  end
end
