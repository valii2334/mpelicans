# frozen_string_literal: true

Aws.config.update(
  {
    region: ENV.fetch('S3_REGION', nil),
    credentials: Aws::Credentials.new(
      ENV.fetch('S3_ACCESS_KEY_ID', nil),
      ENV.fetch('S3_SECRET_ACCESS_KEY', nil)
    )
  }
)
