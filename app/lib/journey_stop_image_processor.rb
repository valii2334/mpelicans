# frozen_string_literal: true

class JourneyStopImageProcessor
  attr_accessor :journey_stop, :images_paths

  def initialize(journey_stop_id:)
    @journey_stop = JourneyStop.find(journey_stop_id)
  end

  def run
    journey_stop.processing!
    journey_stop.images.destroy_all
    journey_stop.uploaded_images.each { |image| attach_image_to_journey_stop(uploaded_image: image) }
    journey_stop.processed!
  end

  private

  def download_image(image_path:)
    Storage.download(key: image_path).body
  end

  def attach_image_to_journey_stop(uploaded_image:)
    journey_stop.images.attach(
      io: download_image(image_path: uploaded_image.s3_key),
      filename: uploaded_image.s3_key
    )
  end
end
