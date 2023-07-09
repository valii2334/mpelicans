# frozen_string_literal: true

require 'async'
require 'async/barrier'

module ImagesProcessors
  class Uploader < ImagesProcessors::Base
    attr_accessor :imageable_id, :imageable_type, :saved_files_paths

    def initialize(imageable_id:, imageable_type:, saved_files_paths:)
      @imageable_id = imageable_id
      @imageable_type = imageable_type
      @saved_files_paths = saved_files_paths
    end

    # rubocop:disable Metrics/MethodLength
    def run_processor
      barrier = Async::Barrier.new
      Async do
        @saved_files_paths.each do |saved_file_path|
          file_path = File.basename(saved_file_path)

          barrier.async do
            upload_image(key: file_path, body: File.read(saved_file_path))
            create_uploaded_image(s3_key: file_path)
            remove_file(saved_file_path:)
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

    def remove_file(saved_file_path:)
      FileUtils.rm_f(saved_file_path)
    end
  end
end
