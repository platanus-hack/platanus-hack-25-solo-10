class HomeController < ApplicationController
  def index
    @video_transcription = VideoTranscription.new
  end
end

