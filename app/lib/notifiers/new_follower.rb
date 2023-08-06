# frozen_string_literal: true

module Notifiers
  class NewFollower < Base
    attr_reader :receiver, :sender

    # rubocop:disable Lint/MissingSuper
    def initialize(receiver_id:, sender_id:)
      @receiver = User.find(receiver_id)
      @sender = User.find(sender_id)
    end
    # rubocop:enable Lint/MissingSuper

    private

    def notification_class
      Notifications::NewFollower
    end

    def attributes(receiver:)
      {
        sender_id: sender.id,
        receiver_id: receiver.id
      }
    end
  end
end
