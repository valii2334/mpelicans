# frozen_string_literal: true

# Create notifications
module Notifiers
  class Base
    def notify
      return unless should_notify?

      receivers.each do |receiver|
        notification_class.find_or_create_by(
          attributes(receiver:)
        )
      end
    end

    private

    def should_notify?
      notification_class.should_notify?(notifier: self)
    end

    def receivers
      notification_class.receivers(notifier: self)
    end

    def attributes(receiver:)
      raise NotImplementedError
    end
  end
end
