class AddPlaceItToMapPins < ActiveRecord::Migration[7.0]
  def change
    add_column :map_pins, :place_id, :string
  end
end
