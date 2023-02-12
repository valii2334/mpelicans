# frozen_string_literal: true

# Notification class
class Notification < ApplicationRecord
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

  def notification_text
    return "#{sender.username} just bought #{journey.title}." if bought_journey?
    return "#{sender.username} created a new journey: #{journey.title}." if new_journey?

    "#{sender.username} added a new stop to #{journey.title}."
  end

  def notification_link
    return pelican_url(username: sender.username) if bought_journey?
    return journey_url(id: journey.id)            if new_journey?

    journey_journey_stop_url(id: journey_stop.id)
  end
end
