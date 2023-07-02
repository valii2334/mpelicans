class ChangeLatLongToDouble < ActiveRecord::Migration[7.0]
  def change
    remove_column :journeys,      :lat,  :string, null: false
    remove_column :journeys,      :long, :string, null: false
    remove_column :journey_stops, :lat,  :string, null: false
    remove_column :journey_stops, :long, :string, null: false

    add_column :journeys,      :lat,  :float, null: false
    add_column :journeys,      :long, :float, null: false
    add_column :journey_stops, :lat,  :float, null: false
    add_column :journey_stops, :long, :float, null: false
  end
end
