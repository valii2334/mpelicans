# frozen_string_literal: true

module ImagesProcessors
  class Validator < ImagesProcessors::Base
    attr_accessor :imageable_id, :imageable_type, :http_uploaded_files

    # rubocop:disable Lint/MissingSuper
    def initialize(imageable_id:, imageable_type:, http_uploaded_files:)
      @imageable_id = imageable_id
      @imageable_type = imageable_type
      @http_uploaded_files = http_uploaded_files
    end
    # rubocop:enable Lint/MissingSuper

    def run_processor
      @http_uploaded_files = @http_uploaded_files.select do |http_uploaded_file|
        http_uploaded_file.content_type.match?(ACCEPTED_CONTENT_TYPE)
      end

      @http_uploaded_files
    end

    private

    def enque_next_steps
      ImagesProcessors::Uploader.new(
        imageable_id:,
        imageable_type:,
        http_uploaded_files:
      ).run
    end
  end
end
