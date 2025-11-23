class InitDiscussionJob < ApplicationJob
  include ActionView::RecordIdentifier

  def perform(video_transcription_id)
    video_transcription = VideoTranscription.find(video_transcription_id)

    %w[marco giorgio veronica dominga].each do |agent|
      AskAgentJob.perform_now(video_transcription_id, agent, video_transcription.initial_question)
    end

    AskAgentJob.perform_now(video_transcription_id, 'camila', "Busca al menos una fuente externa confiable para responder la duda inicial del usuario y dar el veredicto final")

    evaluator = Evaluate.new(video_transcription_id: video_transcription_id)
    response = evaluator.ask("responde con una puntuación de 0 a 100 de la veracidad de la afirmación del video. No digas nada más.")

    score = response.content.match(/\b([1-9]?[0-9]|100)\b/)[0]

    video_transcription.update!(score: score)

    Turbo::StreamsChannel.broadcast_replace_to(
      video_transcription,
      target: dom_id(video_transcription, :score),
      partial: "video_transcriptions/score",
      locals: { video_transcription: video_transcription }
    )
  end
end