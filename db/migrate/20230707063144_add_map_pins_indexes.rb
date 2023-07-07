class AddMapPinsIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :map_pins, :user_id
    add_index :map_pins, :journey_stop_id
    add_index :map_pins, [:user_id, :journey_stop_id], unique: true
  end
end
