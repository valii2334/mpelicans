# frozen_string_literal: true

require 'async'
require 'async/barrier'

module ImagesProcessors
  class Uploader < ImagesProcessors::Base
    attr_accessor :imageable_id, :imageable_type, :database_images_ids

    # rubocop:disable Lint/MissingSuper
    def initialize(imageable_id:, imageable_type:, database_images_ids:)
      @imageable_id = imageable_id
      @imageable_type = imageable_type
      @database_images_ids = database_images_ids
    end
    # rubocop:enable Lint/MissingSuper

    # rubocop:disable Metrics/MethodLength
    def run_processor
      barrier = Async::Barrier.new
      Async do
        @database_images_ids.each do |database_images_id|
          database_image = DatabaseImage.find(database_images_id)
          file_path = "#{SecureRandom.uuid}#{database_image.file_extension}"

          barrier.async do
            upload_image(key: file_path, body: database_image.data)
            create_uploaded_image(s3_key: file_path)
            remove_database_image(database_image:)
          end
        end
        barrier.wait
      end
    end
    # rubocop:enable Metrics/MethodLength

    private

    def enque_next_steps
      JourneyJobs::ProcessImages.perform_async(imageable_id, imageable_type)
    end

    def upload_image(key:, body:)
      Storage.upload(key:, body:)
    end

    def create_uploaded_image(s3_key:)
      UploadedImage.create(imageable:, s3_key:)
    end

    def remove_database_image(database_image:)
      database_image.destroy
    end
  end
end
