class VideoTranscription < ApplicationRecord
  include ActionView::RecordIdentifier

  has_one_attached :media
  has_many_attached :captures

  after_commit :broadcast_update, on: [:update]

  private

  def broadcast_update
    Turbo::StreamsChannel.broadcast_replace_to(self, target: dom_id(self), partial: "video_transcriptions/content", locals: { video_transcription: self })
  end
end
