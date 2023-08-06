# frozen_string_literal: true

module NotifierJobs
  class NewJourneyStop
    include Sidekiq::Job

    def perform(*args)
      journey_id      = args[0]
      journey_stop_id = args[1]
      sender_id       = args[2]

      Notifiers::NewJourneyStop.new(
        journey_id:,
        journey_stop_id:,
        sender_id:
      ).notify
    end
  end
end
