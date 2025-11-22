class VideoTranscriptionsController < ApplicationController
  def index
    @video_transcriptions = VideoTranscription.order(created_at: :desc)
  end

  def new
    @video_transcription = VideoTranscription.new
  end

  def create
    @video_transcription = VideoTranscription.find_or_create_by!(url: url_param)

    DownloadVideoJob.perform_later(@video_transcription.url)

    redirect_to @video_transcription, notice: 'Video transcription está siendo descargado.'
  end

  def show
    @video_transcription = find_video_transcription
  end

  def destroy
    @video_transcription = find_video_transcription
    @video_transcription.destroy!

    redirect_to video_transcriptions_path, notice: 'Video transcription fue eliminado exitosamente.'
  end

  private

  def find_video_transcription
    VideoTranscription.find(params[:id])
  end

  def url_param
    params.require(:video_transcription).permit(:url)[:url]
  end
end

