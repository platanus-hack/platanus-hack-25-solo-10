require 'open3'

class DownloadVideoJob < ApplicationJob
  include ActionView::RecordIdentifier

  def perform(url)
    video = VideoTranscription.find_or_create_by!(url: url)

    return if video.media.attached?

    key = SecureRandom.uuid
    cmd = "yt-dlp -f 'best[ext=webm]/best' --merge-output-format webm --write-thumbnail --convert-thumbnails jpg #{url} -o downloads/#{key}.webm"
    _, status = Open3.capture2(cmd)

    if status.success?
      video_path = Rails.root.join("downloads", "#{key}.webm")

      video.media.attach(io: File.open(video_path), filename: "#{key}.webm", content_type: "video/webm")

      video.media.blob.analyze

      video.captures.attach(io: File.open(Rails.root.join("downloads", "#{key}.webm.jpg")), filename: "#{key}.webm.jpg", content_type: "image/jpeg")

      duration = video.media.blob.metadata["duration"]

      split_duration = duration.to_i / 3

      (0..2).each do |i|
        total_seconds = split_duration * (i + 1)
        hours = total_seconds / 3600
        minutes = (total_seconds % 3600) / 60
        seconds = total_seconds % 60

        time_string = "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"

        capture_filename = "#{key}_captura_#{i + 1}_#{total_seconds}s.jpg"
        capture_path = Rails.root.join("downloads", capture_filename)

        ffmpeg_cmd = "ffmpeg -ss #{time_string} -i #{video_path} -vframes 1 -q:v 2 -y #{capture_path}"
        _, capture_status = Open3.capture2(ffmpeg_cmd)

        if capture_status.success? && File.exist?(capture_path)
          video.captures.attach(
            io: File.open(capture_path),
            filename: capture_filename,
            content_type: "image/jpeg"
          )
        end
      end

      video.reload

      Turbo::StreamsChannel.broadcast_replace_to(
        video,
        target: dom_id(video),
        partial: "video_transcriptions/content",
        locals: { video_transcription: video }
      )

      TranscribeVideoJob.perform_later(video.id)
    end
  end
end
