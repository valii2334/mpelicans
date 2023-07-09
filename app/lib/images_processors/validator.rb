# frozen_string_literal: true

module ImagesProcessors
  class Validator < ImagesProcessors::Base
    attr_accessor :imageable_id, :imageable_type, :http_uploaded_files

    def initialize(imageable_id:, imageable_type:, http_uploaded_files:)
      @imageable_id = imageable_id
      @imageable_type = imageable_type
      @http_uploaded_files = http_uploaded_files
    end

    def run_processor
      @http_uploaded_files = @http_uploaded_files.select do |http_uploaded_file|
        ACCEPTED_CONTENT_TYPES.include?(http_uploaded_file.content_type)
      end

      @http_uploaded_files
    end

    private

    def enque_next_steps
      ImagesProcessors::Saver.new(
        imageable_id:,
        imageable_type:,
        http_uploaded_files:
      ).run
    end
  end
end
