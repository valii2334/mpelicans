# frozen_string_literal: true

module Notifications
  class BoughtJourney < Notification
    validates :journey, presence: true

    def notification_text
      "#{sender.username} just bought #{journey.title}."
    end

    def notification_link
      pelican_path(username: sender.username)
    end

    def notification_title
      'Someone bought your journey!'
    end

    class << self
      def receivers(notifier:)
        [notifier.journey.user]
      end

      def should_notify?(notifier:)
        Notifiable.journey_notification(journey: notifier.journey)
      end
    end
  end
end
