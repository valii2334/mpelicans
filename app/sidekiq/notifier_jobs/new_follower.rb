# frozen_string_literal: true

module NotifierJobs
  class NewFollower
    include Sidekiq::Job

    def perform(*args)
      sender_id   = args[0]
      receiver_id = args[1]

      Notifiers::NewFollower.new(
        sender_id:,
        receiver_id:
      ).notify
    end
  end
end
