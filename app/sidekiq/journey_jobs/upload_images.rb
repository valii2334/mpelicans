# frozen_string_literal: true

module JourneyJobs
  class UploadImages
    include Sidekiq::Job

    def perform(*args)
      ImagesProcessors::Uploader.new(
        imageable_id: args[0],
        imageable_type: args[1],
        database_images_ids: args[2]
      ).run
    end
  end
end
