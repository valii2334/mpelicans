# frozen_string_literal: true

class NotifierJob
  include Sidekiq::Job

  def perform(*args)
    journey_id        = args[0]
    notification_type = args[1].to_sym
    sender_id         = args[2]

    Notifier.new(
      journey_id:,
      notification_type:,
      sender_id:
    ).notify
  end
end
