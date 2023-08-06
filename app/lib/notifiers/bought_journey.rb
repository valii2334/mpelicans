# frozen_string_literal: true

module Notifiers
  class BoughtJourney < Base
    attr_reader :journey, :sender

    # rubocop:disable Lint/MissingSuper
    def initialize(journey_id:, sender_id:)
      @journey = Journey.find(journey_id)
      @sender  = User.find(sender_id)
    end
    # rubocop:enable Lint/MissingSuper

    private

    def notification_class
      Notifications::BoughtJourney
    end

    def attributes(receiver:)
      {
        journey_id: journey.id,
        sender_id: sender.id,
        receiver_id: receiver.id
      }
    end
  end
end
