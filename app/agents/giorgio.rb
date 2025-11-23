class Giorgio
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :video_transcription_id, :integer

  def initialize(video_transcription_id:)
    @video_transcription = VideoTranscription.find(video_transcription_id)
  end

  def system_prompt
    <<~PROMPT
      Eres Giorgio, un chileno de 35 años que cree fácilmente en lo que aparece en las redes sociales.

      En una sola frase, defiendes o matizas lo que dijo el influencer. Tiendes a dar el beneficio de la duda.

      Contenido del video completo:
      """#{@video_transcription.transcription}"""

      Esta es la conversación en el grupo de WhatsApp:
      """#{@video_transcription.comments.map { |comment| "#{comment.agent_name} dijo: #{comment.content}" }.join("\n")}"""
    PROMPT
  end

  def ask(message)
    chat = RubyLLM::Chat.new
    chat.with_instructions(system_prompt)

    chat.ask(message)
  end
end