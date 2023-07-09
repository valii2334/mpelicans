# frozen_string_literal: true

module ImagesProcessors
  class Saver < ImagesProcessors::Base
    attr_accessor :imageable_id, :imageable_type, :http_uploaded_files, :saved_files_paths

    # rubocop:disable Lint/MissingSuper
    def initialize(imageable_id:, imageable_type:, http_uploaded_files:)
      @imageable_id = imageable_id
      @imageable_type = imageable_type
      @http_uploaded_files = http_uploaded_files
      @saved_files_paths = []
    end
    # rubocop:enable Lint/MissingSuper

    def run_processor
      @http_uploaded_files.each do |http_uploaded_file|
        file_path = file_path(http_uploaded_file:)

        File.binwrite(file_path, http_uploaded_file.read)

        @saved_files_paths << file_path
      end

      @saved_files_paths
    end

    private

    def file_path(http_uploaded_file:)
      "tmp/#{SecureRandom.uuid}#{File.extname(http_uploaded_file.tempfile)}"
    end

    def enque_next_steps
      JourneyJobs::UploadImages.perform_async(@imageable_id, @imageable_type, @saved_files_paths)
    end
  end
end
