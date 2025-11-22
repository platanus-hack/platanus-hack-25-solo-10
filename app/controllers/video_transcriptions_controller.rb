class VideoTranscriptionsController < ApplicationController
  def index
    @video_transcriptions = VideoTranscription.order(created_at: :desc)
  end

  def show
    @video_transcription = find_video_transcription
  end

  private

  def find_video_transcription
    VideoTranscription.find(params[:id])
  end
end

