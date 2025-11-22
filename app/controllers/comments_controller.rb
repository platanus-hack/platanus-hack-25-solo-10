class CommentsController < ApplicationController
  def create
    @video_transcription = find_video_transcription
    @comment = @video_transcription.comments.build(comment_params)

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @video_transcription }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_entity }
        format.html { redirect_to @video_transcription, alert: 'No se pudo crear el comentario.' }
      end
    end
  end

  private

  def find_video_transcription
    VideoTranscription.find(params[:video_transcription_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :agent)
  end
end

