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

  default_scope { order(created_at: :desc) }
  scope :not_read, -> { where(read: false) }

  def notification_text
    return "#{sender.username} just bought #{journey.title}."            if bought_journey?
    return "#{sender.username} created a new journey: #{journey.title}." if new_journey?

    "#{sender.username} added a new stop to #{journey.title}."
  end

  def notification_link
    return pelican_path(username: sender.username)                                             if bought_journey?
    return journey_path(id: journey.id)                                                        if new_journey?

    journey_journey_stop_path(journey_id: journey_stop.journey.id, id: journey_stop.id)
  end

  def notification_title
    return 'Someone bought your journey!' if bought_journey?
    return 'New journey created!'         if new_journey?

    'New journey stop added!'
  end
end
