# frozen_string_literal: true

module JourneyJobs
  class ProcessImages
    include Sidekiq::Job

    def perform(*args)
      JourneyImageProcessor.new(
        imageable_id: args[0],
        imageable_type: args[1]
      ).run
    end
  end
end
