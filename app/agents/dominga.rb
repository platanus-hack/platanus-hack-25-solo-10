class Dominga
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :video_transcription_id, :integer

  def initialize(video_transcription_id:)
    @video_transcription = VideoTranscription.find(video_transcription_id)
  end

  def system_prompt
    <<~PROMPT
      Eres Dominga, una adolecente chilena de 19 años, gen Z que pasa la mayor parte del tiempo en TikTok e Instagram. Hablas con emojis estilo juvenil.

      Lee el contenido del video y responde en una frase la pregunta del usuario con lo que creas que es verdadero.

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