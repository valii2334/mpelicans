# frozen_string_literal: true

class JourneyStopImageProcessor
  attr_accessor :journey_stop, :images_paths

  def initialize(journey_stop_id:, images_paths:)
    @journey_stop = JourneyStop.find(journey_stop_id)
    @images_paths = images_paths
  end

  def run
    images_paths.each do |image_path|
      attach_image_to_journey_stop_images(
        image: resize_image(image_path:),
        journey_stop:
      )
      remove_image(image_path:)
    end
  end

  private

  def resize_image(image_path:)
    ImageProcessing::MiniMagick.source(image_path).resize_to_limit!(1024, 1024)
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
