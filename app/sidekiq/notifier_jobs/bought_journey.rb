# frozen_string_literal: true

module NotifierJobs
  class BoughtJourney
    include Sidekiq::Job

    def perform(*args)
      journey_id = args[0]
      sender_id  = args[1]

      Notifiers::BoughtJourney.new(
        journey_id:,
        sender_id:
      ).notify
    end
  end
end
