# frozen_string_literal: true

module JourneyStopJobs
  class ProcessImages
    include Sidekiq::Job

    sidekiq_options retry: false

    def perform(*args)
      JourneyStopImageProcessor.new(
        journey_stop_id: args[0],
        images_paths: args[1]
      ).run
    end
  end
end
