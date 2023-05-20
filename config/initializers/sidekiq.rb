# frozen_string_literal: true

Sidekiq.configure_client do |config|
  config.redis = {
    size: Integer(ENV.fetch('SIDEKIQ_REDIS_CLIENT_SIZE', 3)),
    url: ENV.fetch('REDIS_TLS_URL', nil),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    size: Integer(ENV.fetch('SIDEKIQ_REDIS_SIZE', 12)),
    url: ENV.fetch('REDIS_TLS_URL', nil),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end
