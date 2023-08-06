# frozen_string_literal: true

module Notifiers
  class NewJourneyStop < Base
    attr_reader :journey, :journey_stop, :sender

    # rubocop:disable Lint/MissingSuper
    def initialize(journey_id:, journey_stop_id:, sender_id:)
      @journey      = Journey.find(journey_id)
      @journey_stop = JourneyStop.find(journey_stop_id)
      @sender       = User.find(sender_id)
    end
    # rubocop:enable Lint/MissingSuper

    private

    def notification_class
      Notifications::NewJourneyStop
    end

    def attributes(receiver:)
      {
        journey_id: journey.id,
        sender_id: sender.id,
        receiver_id: receiver.id,
        journey_stop_id: journey_stop.id
      }
    end
  end
end
