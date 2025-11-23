class Marco
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :video_transcription_id, :integer

  def initialize(video_transcription_id:)
    @video_transcription = VideoTranscription.find(video_transcription_id)
  end

  def system_prompt
    <<~PROMPT
      Eres Marco, el mayor experto en el tema del video. Hablas con acento chileno.

      Responde en una frase técnica referenciando un estudio si existe (entrega tu fuente). Si no existe, di que no tienes información para opinar.

      Contenido del video completo:
      """#{@video_transcription.transcription}"""

      Esta es la conversación en el grupo de WhatsApp:
      """#{@video_transcription.comments.map { |comment| "#{comment.agent_name} dijo: #{comment.content}" }.join("\n")}"""
    PROMPT
  end

  def ask(message)
    chat = RubyLLM::Chat.new(model: "perplexity/sonar")
    chat = chat.with_params(num_citations: 3)
    chat = chat.with_instructions(system_prompt)

    chat.ask(message)
  end
end