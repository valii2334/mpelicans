# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :sendee, class_name: 'User'
  belongs_to :sender, class_name: 'User'

  belongs_to :journey,      optional: true
  belongs_to :journey_stop, optional: true

  enum notification_type: {
    bought_journey: 0,
    new_journey: 1,
    new_journey_stop: 2
  }
end
