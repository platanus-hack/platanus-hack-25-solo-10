RubyLLM.configure do |config|
  config.openai_api_base = "https://openrouter.ai/api/v1"
  config.openai_api_key = Rails.application.credentials.dig(:openrouter, :api_key)
  config.openrouter_api_key = Rails.application.credentials.dig(:openrouter, :api_key)
  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true
  config.default_model = "openai/gpt-4o"
end
