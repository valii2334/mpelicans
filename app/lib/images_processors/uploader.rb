# frozen_string_literal: true

require 'async'
require 'async/barrier'

module ImagesProcessors
  class Uploader < ImagesProcessors::Base
    attr_accessor :imageable_id, :imageable_type, :http_uploaded_files

    # rubocop:disable Lint/MissingSuper
    def initialize(imageable_id:, imageable_type:, http_uploaded_files:)
      @imageable_id = imageable_id
      @imageable_type = imageable_type
      @http_uploaded_files = http_uploaded_files
    end
    # rubocop:enable Lint/MissingSuper

    # rubocop:disable Metrics/MethodLength
    def run_processor
      barrier = Async::Barrier.new
      Async do
        @http_uploaded_files.each do |http_uploaded_file|
          barrier.async do
            tempfile  = http_uploaded_file.tempfile.open
            file_path = "#{SecureRandom.uuid}#{File.extname(http_uploaded_file.tempfile)}"

            upload_image(key: file_path, body: tempfile.read)
            create_uploaded_image(s3_key: file_path)

            tempfile.close
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
  end
end
