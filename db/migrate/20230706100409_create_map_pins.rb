class CreateMapPins < ActiveRecord::Migration[7.0]
  def change
    create_table :map_pins do |t|
      t.integer :user_id, null: false
      t.integer :journey_stop_id
      t.string :lat, null: false
      t.string :long, null: false

      t.timestamps
    end
  end
end
