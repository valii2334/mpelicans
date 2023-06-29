# frozen_string_literal: true

class JourneyImageProcessor
  attr_accessor :imageable

  def initialize(imageable_id:, imageable_type:)
    @imageable = load_imageable(imageable_id:, imageable_type:)
  end

  def run
    imageable.processing!
    imageable.images.destroy_all
    imageable.uploaded_images.each { |image| attach_image_to_imageable(uploaded_image: image) }
    imageable.process_images
    imageable.processed!
  end

  private

  def load_imageable(imageable_id:, imageable_type:)
    return JourneyStop.find(imageable_id) if imageable_type == 'journey_stop'

    Journey.find(imageable_id)
  end

  def download_image(image_path:)
    Storage.download(key: image_path).body
  end

  def attach_image_to_imageable(uploaded_image:)
    imageable.images.attach(
      io: download_image(image_path: uploaded_image.s3_key),
      filename: uploaded_image.s3_key
    )
  end
end
