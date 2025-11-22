class VideoTranscriptionsController < ApplicationController
  before_action :set_video_transcription, only: [:show, :destroy]

  def index
    @video_transcriptions = VideoTranscription.order(created_at: :desc)
  end

  def new
    @video_transcription = VideoTranscription.new
  end

  def create
    @video_transcription = VideoTranscription.new(video_transcription_params)

    if @video_transcription.save
      DownloadVideoJob.perform_later(@video_transcription.id)
      redirect_to @video_transcription, notice: 'La transcripción de video está siendo descargada.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @video_transcription.destroy!
    redirect_to video_transcriptions_path, notice: 'La transcripción de video fue eliminada exitosamente.'
  end

  private

  def set_video_transcription
    @video_transcription = VideoTranscription.find(params[:id])
  end

  def video_transcription_params
    params.require(:video_transcription).permit(:url, :initial_question)
  end
end
