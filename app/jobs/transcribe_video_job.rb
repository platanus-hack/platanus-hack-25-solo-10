require 'open3'

class TranscribeVideoJob < ApplicationJob
  include ActionView::RecordIdentifier

  def perform(video_transcription_id)
    video_transcription = VideoTranscription.find(video_transcription_id)

    # Obtener la ruta completa (full_path) con nombre de archivo y extensión
    blob = video_transcription.media.blob
    path = ActiveStorage::Blob.service.send(:path_for, blob.key)

    transcription_path = Rails.root.join("downloads", "#{video_transcription_id}.txt")
    cmd = "python3 scripts/transcribe.py #{path} #{transcription_path}"
    _, status = Open3.capture2(cmd)

    if status.success?
      if File.exist?(transcription_path)
        transcription_text = File.read(transcription_path, encoding: "utf-8")
        video_transcription.update!(transcription: transcription_text)

        Turbo::StreamsChannel.broadcast_replace_to(
          video_transcription,
          target: dom_id(video_transcription),
          partial: "video_transcriptions/content",
          locals: { video_transcription: video_transcription }
        )

        question = "Me topé con este video en las redes sociales. Desde tu punto de vista experto, tiene sustento lo que dice el influencer? Debería seguir su consejo?"

        ["marco", "veronica", "camila"].each do |agent|
          AskAgentJob.perform_later(video_transcription.id, agent, question)
        end
      end
    end
  end
end