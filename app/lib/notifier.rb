# frozen_string_literal: true

# Create notifications
class Notifier
  attr_reader :journey, :notification_type, :sender

  def initialize(journey_id:, notification_type:, sender_id:)
    @journey           = Journey.find(journey_id)
    @sender            = User.find(sender_id)
    @notification_type = notification_type
  end

  def notify
    return unless should_notify?

    receivers.each do |receiver|
      Notification.find_or_create_by(
        notification_attributes(receiver:)
      )
    end
  end

  private

  def should_notify?
    journey.public_journey?
  end

  def receivers
    return [journey.user]                                  if bought_journey?
    return sender.followers                                if new_journey?
    return (sender.followers + journey.paying_users).uniq  if new_journey_stop?

    raise StandardError, 'Notifier not implemented for this notification type'
  end

  def bought_journey?
    notification_type == :bought_journey
  end

  def new_journey?
    notification_type == :new_journey
  end

  def new_journey_stop?
    notification_type == :new_journey_stop
  end

  def notification_attributes(receiver:)
    attributes = {
      journey_id: journey.id,
      sender_id: sender.id,
      receiver_id: receiver.id,
      notification_type:
    }

    attributes[:journey_stop_id] = journey.journey_stops.last.id if new_journey_stop?

    attributes
  end
end
