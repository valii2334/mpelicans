# frozen_string_literal: true

module Notifiers
  class NewJourney < Base
    attr_reader :journey, :sender

    def initialize(journey_id:, sender_id:)
      @journey = Journey.find(journey_id)
      @sender  = User.find(sender_id)

      super
    end

    private

    def notification_class
      Notifications::NewJourney
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
