# frozen_string_literal: true

module Notifications
  class NewJourneyStop < Notification
    validates :journey, presence: true
    validates :journey_stop, presence: true

    def notification_text
      "#{sender.username} added a new stop to #{journey.title}."
    end

    def notification_link
      journey_journey_stop_path(journey_id: journey_stop.journey.id, id: journey_stop.id)
    end

    def notification_title
      'New journey stop added!'
    end

    class << self
      def receivers(notifier:)
        (
          notifier.sender.followers +
          notifier.journey.paying_users
        ).uniq
      end

      def should_notify?(notifier:)
        Notifiable.journey_notification(journey: notifier.journey)
      end
    end
  end
end
