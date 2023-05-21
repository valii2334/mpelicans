# frozen_string_literal: true

$redis = Redis.new(url: ENV.fetch('REDIS_TLS_URL', nil), ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
