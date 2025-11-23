class AddScoreToVideoTRanscription < ActiveRecord::Migration[8.1]
  def change
    add_column :video_transcriptions, :score, :integer
  end
end
