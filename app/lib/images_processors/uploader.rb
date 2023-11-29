# frozen_string_literal: true

require 'async'
require 'async/barrier'

module ImagesProcessors
  class Uploader < ImagesProcessors::Base
    attr_accessor :imageable_id, :imageable_type, :http_uploaded_files, :file_paths

    # rubocop:disable Lint/MissingSuper
    def initialize(imageable_id:, imageable_type:, http_uploaded_files:)
      @imageable_id = imageable_id
      @imageable_type = imageable_type
      @http_uploaded_files = http_uploaded_files
      @file_paths = construct_file_paths
    end
    # rubocop:enable Lint/MissingSuper

    # rubocop:disable Metrics/MethodLength
    def run_processor
      Rails.logger.info("Started uploading images for #{imageable_id} #{imageable_type}")

      barrier = Async::Barrier.new
      Async do
        @http_uploaded_files.each_with_index do |http_uploaded_file, index|
          barrier.async do
            Rails.logger.info("Started uploading image #{index} for #{imageable_id} #{imageable_type}")
            tempfile  = http_uploaded_file.tempfile.open
            file_path = @file_paths[index]

            upload_image(key: file_path, body: tempfile.read)

            tempfile.close
            Rails.logger.info("Finished uploading image #{index} for #{imageable_id} #{imageable_type}")
          end
        end
        barrier.wait
      end

      create_uploaded_images

      Rails.logger.info("Finished uploading images for #{imageable_id} #{imageable_type}")
    end
    # rubocop:enable Metrics/MethodLength

    private

    def create_uploaded_images
      @file_paths.each do |file_path|
        create_uploaded_image(s3_key: file_path)
      end
    end

    def construct_file_paths
      @http_uploaded_files.map do |http_uploaded_file|
        "#{SecureRandom.uuid}#{File.extname(http_uploaded_file.tempfile)}"
      end
    end

    def enque_next_steps
      JourneyJobs::ProcessImages.perform_async(imageable_id, imageable_type)
    end

    def upload_image(key:, body:)
      Storage.upload(key:, body:)
    end

    def create_uploaded_image(s3_key:)
      UploadedImage.create(imageable:, s3_key:)
    end
  end
end
