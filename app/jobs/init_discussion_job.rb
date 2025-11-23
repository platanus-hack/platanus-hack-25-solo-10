class InitDiscussionJob < ApplicationJob
  def perform(video_transcription_id)
    video_transcription = VideoTranscription.find(video_transcription_id)

    %w[marco giorgio veronica dominga].each do |agent|
      AskAgentJob.perform_now(video_transcription_id, agent, video_transcription.initial_question)
    end
    AskAgentJob.perform_now(video_transcription_id, 'camila', "Busca al menos una fuente externa confiable para responder la duda inicial del usuario y dar el veredicto final")
  end
end