require 'open3'

class TranscribeVideoJob < ApplicationJob
  def perform(url)
    key = SecureRandom.uuid
    cmd = "python3 transcribe.py #{url} #{key}"
    _, status = Open3.capture2(cmd)

    if status.success?
      transcription_path = Rails.root.join("downloads", "#{key}.txt")
      if File.exist?(transcription_path)
        transcription_text = File.read(transcription_path, encoding: "utf-8")
        VideoTranscription.create!(url: url, transcription: transcription_text)
      end
    end
  end
end