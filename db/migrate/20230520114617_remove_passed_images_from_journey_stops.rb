class RemovePassedImagesFromJourneyStops < ActiveRecord::Migration[7.0]
  def change
    remove_column :journey_stops, :passed_images, :boolean
    add_column :journey_stops, :passed_images_count, :integer
  end
end
