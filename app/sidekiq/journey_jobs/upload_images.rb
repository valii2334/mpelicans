# frozen_string_literal: true

module JourneyJobs
  class UploadImages
    include Sidekiq::Job

    def perform(*args)
      ImagesProcessors::Uploader.new(
        imageable_id: args[0],
        imageable_type: args[1],
        saved_files_paths: args[2]
      ).run
    end
  end
end
