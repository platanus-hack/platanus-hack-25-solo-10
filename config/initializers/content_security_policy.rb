Rails.application.configure do
    config.content_security_policy do |policy|
      policy.default_src :self, :https
      policy.font_src    :self, :https, :data
      policy.object_src  :none
  
      if Rails.env.development?
        vite_host = "http://localhost:#{ViteRuby.config.port}"
        vite_ws = "ws://localhost:#{ViteRuby.config.port}"
  
        # Allow HTTP in development for localhost (Active Storage, etc.)
        policy.img_src     :self, :https, :http, :data, :blob, "http://localhost:*"
        policy.script_src  :self, :https, :http, :unsafe_eval, :unsafe_inline, vite_host
        policy.style_src   :self, :https, :http, :unsafe_inline
        policy.connect_src :self, :https, :http, vite_host, vite_ws, "http://localhost:*", "ws://localhost:*"
      else
        policy.img_src     :self, :https, :data, :blob
        policy.script_src  :self, :https
        policy.style_src   :self, :https
      end
    end
  
    config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  
    if Rails.env.development?
      config.content_security_policy_nonce_directives = %w[]
    else
      config.content_security_policy_nonce_directives = %w[script-src style-src]
    end
  end
  