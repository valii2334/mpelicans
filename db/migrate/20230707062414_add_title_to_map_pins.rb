class AddTitleToMapPins < ActiveRecord::Migration[7.0]
  def change
    add_column :map_pins, :title, :string
  end
end
