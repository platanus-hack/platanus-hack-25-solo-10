# == Schema Information
#
# Table name: messages
#
#  cache_creation_tokens :integer
#  cached_tokens         :integer
#  chat_id               :integer          not null
#  content               :text
#  content_raw           :json
#  created_at            :datetime         not null
#  id                    :integer          not null, primary key
#  input_tokens          :integer
#  model_id              :integer
#  output_tokens         :integer
#  role                  :string           not null
#  tool_call_id          :integer
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_messages_on_chat_id       (chat_id)
#  index_messages_on_model_id      (model_id)
#  index_messages_on_role          (role)
#  index_messages_on_tool_call_id  (tool_call_id)
#

class Message < ApplicationRecord
  acts_as_message tool_calls_foreign_key: :message_id
  has_many_attached :attachments
  broadcasts_to ->(message) { "chat_#{message.chat_id}" }

  def broadcast_append_chunk(content)
    broadcast_append_to "chat_#{chat_id}",
      target: "message_#{id}_content",
      partial: "messages/content",
      locals: { content: content }
  end
end
