class AskAgentJob < ApplicationJob
  def perform(video_transcription_id, agent_class_name, message)
    agent = agent_class_name.capitalize.constantize.new(video_transcription_id: video_transcription_id)
    response = agent.ask(message)

    Comment.create!(
      video_transcription_id: video_transcription_id,
      agent: agent_class_name,
      content: response.content
    )
  end
end