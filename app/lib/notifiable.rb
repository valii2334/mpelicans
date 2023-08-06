# frozen_string_literal: true

class Notifiable
  class << self
    def journey_notification(journey:)
      journey.public_journey? ||
        journey.monetized_journey?
    end
  end
end
