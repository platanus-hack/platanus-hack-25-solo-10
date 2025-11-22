# == Schema Information
#
# Table name: comments
#
#  agent                  :string           not null
#  content                :text
#  created_at             :datetime         not null
#  id                     :integer          not null, primary key
#  updated_at             :datetime         not null
#  video_transcription_id :integer          not null
#
# Indexes
#
#  index_comments_on_video_transcription_id  (video_transcription_id)
#

class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :video_transcription

  validates :content, presence: true
  validates :agent, presence: true

  after_create_commit :broadcast_append

  def agent_name
    case agent
    when 'Veronica'
      'Verónica Fuentes'
    when 'Marco'
      'Dr. Marcos Salazar'
    when 'Camila'
      'Abogada Camila Echeverría'
    when 'Usuario'
      'Usuario'
    else
      agent
    end
  end

  def agent_color
    case agent
    when 'Veronica'
      'bg-blue-500'
    when 'Marco'
      'bg-green-500'
    when 'Camila'
      'bg-purple-500'
    when 'Usuario'
      'bg-gray-600'
    else
      'bg-gray-500'
    end
  end

  private

  def broadcast_append
    Turbo::StreamsChannel.broadcast_append_to(
      video_transcription,
      target: "comments_#{video_transcription.id}",
      partial: 'comments/comment',
      locals: { comment: self }
    )
  end
end
