class RecreateMapPins < ActiveRecord::Migration[7.0]
  def change
    drop_table :map_pins

    create_table :map_pins do |t|
      t.integer :user_id, null: false
      t.integer :journey_stop_id
      t.float :lat, null: false
      t.float :long, null: false

      t.timestamps
    end
  end
end
