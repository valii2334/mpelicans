class AddLatestJourneyStopAddedAtToJourneys < ActiveRecord::Migration[7.0]
  def change
    add_column :journeys, :latest_journey_stop_added_at, :datetime, null: false
  end
end
