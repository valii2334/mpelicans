class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :sendee_id, null: false
      t.integer :sender_id, null: false
      t.integer :notification_type, null: false, default: 0
      t.integer :journey_id
      t.integer :journey_stop_id

      t.timestamps
    end
  end
end
