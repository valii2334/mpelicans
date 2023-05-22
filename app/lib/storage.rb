# frozen_string_literal: true

class Storage
  def self.upload(key:, body:)
    Aws::S3::Client.new.put_object(
      {
        bucket: ENV.fetch('S3_BUCKET', nil),
        acl: 'private',
        body:,
        key:
      }
    )
  end

  def self.download(key:)
    Aws::S3::Client.new.get_object(
      {
        bucket: ENV.fetch('S3_BUCKET', nil),
        key:
      }
    )
  end

  def self.delete(key:)
    Aws::S3::Client.new.delete_object(
      {
        bucket: ENV.fetch('S3_BUCKET', nil),
        key:
      }
    )
  end
end
