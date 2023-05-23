# frozen_string_literal: true

# Notification class
class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :sender,   class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  belongs_to :journey
  belongs_to :journey_stop, optional: true

  enum notification_type: {
    bought_journey: 0,
    new_journey: 1,
    new_journey_stop: 2
  }

  validates :journey_stop, presence: true, if: -> { new_journey_stop? }

  default_scope { where(read: false).order(created_at: :desc) }

  def notification_text
    return "#{sender.username} just bought #{journey.title}."            if bought_journey?
    return "#{sender.username} created a new journey: #{journey.title}." if new_journey?
    return "#{sender.username} added a new stop to #{journey.title}."    if new_journey_stop?

    raise StandardError, 'Notification next not implemented for this notification type'
  end

  def notification_link
    return pelican_path(username: sender.username)                                             if bought_journey?
    return journey_path(id: journey.id)                                                        if new_journey?
    return journey_journey_stop_path(journey_id: journey_stop.journey.id, id: journey_stop.id) if new_journey_stop?

    raise StandardError, 'Notification link not implemented for this notification type'
  end

  def notification_title
    return 'Someone bought your journey!' if bought_journey?
    return 'New journey created!'         if new_journey?
    return 'New journey stop added!'      if new_journey_stop?

    raise StandardError, 'Notification title not implemented for this notification type'
  end
end
