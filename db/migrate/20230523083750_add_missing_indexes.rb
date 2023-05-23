# frozen_string_literal: true

class AddMissingIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :paid_journeys, :user_id
    add_index :paid_journeys, :journey_id

    add_index :journey_stops, :journey_id

    add_index :journeys, :user_id

    add_index :notifications, :journey_id
    add_index :notifications, :journey_stop_id
    add_index :notifications, :sender_id
    add_index :notifications, :receiver_id

    add_index :relationships, :follower_id
    add_index :relationships, :followee_id
  end
end
