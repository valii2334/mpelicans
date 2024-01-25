# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = {
    size: Integer(ENV.fetch('SIDEKIQ_REDIS_SIZE') { 7 }),
    url: ENV.fetch('REDIS_URL', nil),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    size: Integer(ENV.fetch('SIDEKIQ_REDIS_CLIENT_SIZE') { 1 }),
    url: ENV.fetch('REDIS_URL', nil),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end
