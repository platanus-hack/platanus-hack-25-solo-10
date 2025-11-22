class CreateVideoTranscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :video_transcriptions do |t|
      t.timestamps

      t.string :url, null: false
      t.string :transcription
    end
  end
end
