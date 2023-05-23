# frozen_string_literal: true

class JourneyStopImageProcessor
  attr_accessor :journey_stop, :images_paths

  def initialize(journey_stop_id:)
    @journey_stop = JourneyStop.find(journey_stop_id)
  end

  def run
    journey_stop.images.destroy_all
    journey_stop.processing!
    journey_stop.uploaded_images.each do |uploaded_image|
      image_path = uploaded_image.s3_key

      attach_image_to_journey_stop_images(
        image: resize_image(image_path:),
        journey_stop:
      )
      remove_image(image_path:)
    end

    journey_stop.processed!
  end

  private

  def resize_image(image_path:)
    File.binwrite(
      image_path,
      Storage.download(key: image_path).body.read
    )

    ImageProcessing::MiniMagick
      .source(image_path)
      .resize_to_limit!(
        JourneyStop::MAX_IMAGE_WIDTH,
        JourneyStop::MAX_IMAGE_HEIGHT
      )
  end

  def attach_image_to_journey_stop_images(journey_stop:, image:)
    journey_stop.images.attach(
      io: image,
      filename: File.basename(image)
    )
  end

  def remove_image(image_path:)
    FileUtils.safe_unlink image_path
  end
end
