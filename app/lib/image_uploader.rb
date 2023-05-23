# frozen_string_literal: true

require 'async'
require 'async/barrier'

class ImageUploader
  ACCEPTED_CONTENT_TYPES = ['image/png', 'image/jpg', 'image/jpeg'].freeze

  attr_accessor :journey_stop_id, :uploaded_files

  def initialize(journey_stop_id:, uploaded_files:)
    @journey_stop_id = journey_stop_id
    @uploaded_files = uploaded_files.select do |uploaded_file|
      ACCEPTED_CONTENT_TYPES.include?(uploaded_file.content_type)
    end
  end

  def run
    barrier = Async::Barrier.new
    Async do
      @uploaded_files.each do |uploaded_file|
        barrier.async do
          upload_image(key: create_uploaded_image(image: uploaded_file).s3_key, image: uploaded_file)
        end
      end
      barrier.wait
    end
  end

  private

  def upload_image(key:, image:)
    Storage.upload(
      key:,
      body: image.tempfile.read
    )
  end

  def generate_s3_key(image:)
    "#{journey_stop_id}-#{SecureRandom.uuid}#{File.extname(image.tempfile)}"
  end

  def create_uploaded_image(image:)
    UploadedImage.create(journey_stop_id:, s3_key: generate_s3_key(image:))
  end
end
