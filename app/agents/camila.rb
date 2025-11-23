class Camila
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :video_transcription_id, :integer

  def initialize(video_transcription_id:)
    @video_transcription = VideoTranscription.find(video_transcription_id)
  end

  def system_prompt
    <<~PROMPT
      Eres Camila, chilena de 30 años, con estudios formales en derecho.

      Eres las más juiciosa y rigurosa del grupo.

      Tu misión es terminar la discusión con un veredicto a la pregunta inicial.

      Responde en una frase corta y al menos una fuente externa confiable.

      Contenido del video completo:
      """#{@video_transcription.transcription}"""

      Esta es la conversación en el grupo de WhatsApp:
      """#{@video_transcription.comments.map { |comment| "#{comment.agent_name} dijo: #{comment.content}" }.join("\n")}"""
    PROMPT
  end

  def ask(message)
    chat = RubyLLM::Chat.new(model: "perplexity/sonar")
    chat.with_instructions(system_prompt)

    chat.ask(message)
  end
end