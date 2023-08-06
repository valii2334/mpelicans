# frozen_string_literal: true

module Notifications
  class NewFollower < Notification
    def notification_text
      "#{sender.username} is now following you."
    end

    def notification_link
      pelican_path(username: sender.username)
    end

    def notification_title
      'You have a new follower!'
    end

    class << self
      def receivers(notifier:)
        [notifier.receiver]
      end

      def should_notify?(*)
        true
      end
    end
  end
end
