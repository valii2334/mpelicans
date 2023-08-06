# frozen_string_literal: true

# Notification class
class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :sender,   class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  belongs_to :journey,      optional: true
  belongs_to :journey_stop, optional: true

  default_scope { order(created_at: :desc) }
  scope :not_read, -> { where(read: false) }

  def notification_text
    raise NotImplementedError
  end

  def notification_link
    raise NotImplementedError
  end

  def notification_title
    raise NotImplementedError
  end
end
