class AddPassedImagesToJourneyStop < ActiveRecord::Migration[7.0]
  def change
    add_column :journey_stops, :passed_images, :boolean, default: false, null: false
  end
end
