# frozen_string_literal: true

module ImagesProcessors
  class Saver < ImagesProcessors::Base
    attr_accessor :imageable_id, :imageable_type, :http_uploaded_files, :database_images_ids

    # rubocop:disable Lint/MissingSuper
    def initialize(imageable_id:, imageable_type:, http_uploaded_files:)
      @imageable_id = imageable_id
      @imageable_type = imageable_type
      @http_uploaded_files = http_uploaded_files
      @database_images_ids = []
    end
    # rubocop:enable Lint/MissingSuper

    def run_processor
      @http_uploaded_files.each do |http_uploaded_file|
        database_image = DatabaseImage.create(
          data: http_uploaded_file.read,
          file_extension: File.extname(http_uploaded_file.tempfile)
        )

        @database_images_ids << database_image.id
      end

      @database_images_ids
    end

    private

    def enque_next_steps
      JourneyJobs::UploadImages.perform_async(@imageable_id, @imageable_type, @database_images_ids)
    end
  end
end
