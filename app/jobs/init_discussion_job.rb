class InitDiscussionJob < ApplicationJob
  def perform(video_transcription_id)
    video_transcription = VideoTranscription.find(video_transcription_id)

    %w[giorgio dominga rosa].each do |agent|
      AskAgentJob.perform_now(video_transcription_id, agent, video_transcription.initial_question)
    end

    AskAgentJob.perform_now(video_transcription_id, 'giorgio', "Reacciona a lo que dijeron los otros agentes e intenta argumentar tu posición.")
    AskAgentJob.perform_now(video_transcription_id, 'dominga', "Reacciona a lo que dijeron los otros agentes e intenta argumentar tu posición.")
    AskAgentJob.perform_now(video_transcription_id, 'rosa', "¿Apoyas el comentario de tus compañeros?")
    AskAgentJob.perform_now(video_transcription_id, 'camila', "Cual es el veredicto final de la conversación?")
  end
end