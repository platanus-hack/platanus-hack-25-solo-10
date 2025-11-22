# == Schema Information
#
# Table name: chats
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  model_id   :integer
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chats_on_model_id  (model_id)
#

class Chat < ApplicationRecord
  acts_as_chat messages_foreign_key: :chat_id
end
