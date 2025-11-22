# == Schema Information
#
# Table name: video_transcriptions
#
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  initial_question :string
#  transcription    :string
#  updated_at       :datetime         not null
#  url              :string           not null
#

class VideoTranscription < ApplicationRecord
  include ActionView::RecordIdentifier

  has_one_attached :media
  has_many_attached :captures
  has_many :comments, dependent: :destroy

  after_commit :broadcast_update, on: [:update]

  validates :initial_question, presence: true
  validates :url, presence: true

  private

  def broadcast_update
    Turbo::StreamsChannel.broadcast_replace_to(self, target: dom_id(self), partial: "video_transcriptions/content", locals: { video_transcription: self })
  end
end
