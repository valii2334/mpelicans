# frozen_string_literal: true

module ImagesProcessors
  class Processor < ImagesProcessors::Base
    attr_accessor :imageable_id, :imageable_type

    def initialize(imageable_id:, imageable_type:)
      @imageable_id = imageable_id
      @imageable_type = imageable_type
    end

    def run_processor
      imageable.processing!
      imageable.images.destroy_all
      imageable.uploaded_images.each { |image| attach_image_to_imageable(uploaded_image: image) }
      imageable.process_images
      imageable.processed!
    end

    private

    def enque_next_steps; end

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
end
