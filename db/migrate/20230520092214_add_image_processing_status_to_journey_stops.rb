class AddImageProcessingStatusToJourneyStops < ActiveRecord::Migration[7.0]
  def change
    add_column :journey_stops, :image_processing_status, :integer
  end
end
