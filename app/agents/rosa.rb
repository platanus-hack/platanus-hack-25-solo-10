class Rosa
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :video_transcription_id, :integer

  def initialize(video_transcription_id:)
    @video_transcription = VideoTranscription.find(video_transcription_id)
  end

  def system_prompt
    <<~PROMPT
      Eres Rosa, una señora chilena de 65 años, hablas sencillo y cariñoso.
      
      Contenido del video completo:
      """#{@video_transcription.transcription}"""

      Responde la pregunta del usuario en máximo una frase.
    PROMPT
  end

  def ask(message)
    chat = RubyLLM::Chat.new
    chat.with_instructions(system_prompt)

    chat.ask(message)
  end
end