class Evaluate
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :video_transcription_id, :integer

  def initialize(video_transcription_id:)
    @video_transcription = VideoTranscription.find(video_transcription_id)
  end

  def system_prompt
    <<~PROMPT
      Eres un evaluador de la conversación en el grupo de WhatsApp.

      Lee el contenido del video y la conversación en el grupo de WhatsApp y evalúa si la afirmación del video es verdadera o falsa.

      Contenido del video completo:
      """#{@video_transcription.transcription}"""

      Estto es lo que opinaron loas agentes:
      """#{@video_transcription.comments.map { |comment| "#{comment.agent_name} dijo: #{comment.content}" }.join("\n")}"""

      Responde con una puntuación de 0 a 100 de la veracidad de la afirmación del video.

      100: Verdadero
      70: Verdad parcial
      50: Indeciso
      30: Probablemente falso
      0: Falso
    PROMPT
  end

  def ask(message)
    chat = RubyLLM::Chat.new
    chat = chat.with_instructions(system_prompt)

    chat.ask(message)
  end
end