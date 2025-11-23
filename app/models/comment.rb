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

  enum :agent, {
    veronica: 'veronica',
    dominga: 'dominga',
    giorgio: 'giorgio',
    rosa: 'rosa',
    marco: 'marco',
    camila: 'camila',
    user: 'user'
  }

  after_create_commit :broadcast_append

  def agent_color
    case agent
    when 'veronica'
      'bg-blue-500'
    when 'marco'
      'bg-green-500'
    when 'camila'
      'bg-purple-500'
    when 'dominga'
      'bg-pink-500'
    when 'giorgio'
      'bg-orange-500'
    when 'rosa'
      'bg-red-500'
    when 'user'
      'bg-gray-600'
    end
  end

  def agent_name
    case agent
    when 'veronica'
      'Verónica'
    when 'marco'
      'Marco'
    when 'camila'
      'Camila'
    when 'dominga'
      'Dominga'
    when 'giorgio'
      'Giorgio'
    when 'rosa'
      'Rosa'
    when 'user'
      'Usuario'
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
