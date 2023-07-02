class MakeLatLongRequired < ActiveRecord::Migration[7.0]
  def change
    change_column :journeys, :lat, :string, null: false
    change_column :journeys, :long, :string, null: false

    change_column :journey_stops, :lat, :string, null: false
    change_column :journey_stops, :long, :string, null: false
  end
end
