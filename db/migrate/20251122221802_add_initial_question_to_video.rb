class AddInitialQuestionToVideo < ActiveRecord::Migration[8.1]
  def change
    add_column :video_transcriptions, :initial_question, :string
  end
end
