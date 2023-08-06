class AddTypeToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :type, :string
    remove_column :notifications, :notification_type
  end
end
