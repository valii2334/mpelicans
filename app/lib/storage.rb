# frozen_string_literal: true

class Storage
  def self.upload(key:, body:)
    Storage.client.put_object(
      {
        bucket: ENV.fetch('S3_BUCKET', nil),
        acl: 'private',
        body:,
        key:
      }
    )
  end

  def self.download(key:)
    Storage.client.get_object(
      {
        bucket: ENV.fetch('S3_BUCKET', nil),
        key:
      }
    )
  end

  def self.delete(key:)
    Storage.client.delete_object(
      {
        bucket: ENV.fetch('S3_BUCKET', nil),
        key:
      }
    )
  end

  def self.client
    Aws::S3::Client.new(
      {
        region: ENV.fetch('S3_REGION', nil),
        credentials: Aws::Credentials.new(
          ENV.fetch('S3_ACCESS_KEY_ID', nil),
          ENV.fetch('S3_SECRET_ACCESS_KEY', nil)
        )
      }
    )
  end
end
