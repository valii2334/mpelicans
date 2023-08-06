# frozen_string_literal: true

module Notifications
  class NewJourney < Notification
    validates :journey, presence: true

    def notification_text
      "#{sender.username} created a new journey: #{journey.title}."
    end

    def notification_link
      journey_path(id: journey.id)
    end

    def notification_title
      'New journey created!'
    end

    class << self
      def receivers(notifier:)
        notifier.sender.followers
      end

      def should_notify?(notifier:)
        Notifiable.journey_notification(journey: notifier.journey)
      end
    end
  end
end
