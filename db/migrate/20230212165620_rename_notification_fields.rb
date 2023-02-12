class RenameNotificationFields < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :sendee_id, :integer
    remove_column :notifications, :sender_id, :integer

    add_column :notifications, :sender_id,   :integer, null: false
    add_column :notifications, :receiver_id, :integer, null: false
  end
end
