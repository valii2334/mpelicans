class AddPlaceItToJourneyStops < ActiveRecord::Migration[7.0]
  def change
    add_column :journey_stops, :place_id, :string
  end
end
