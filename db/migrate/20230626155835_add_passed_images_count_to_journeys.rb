class AddPassedImagesCountToJourneys < ActiveRecord::Migration[7.0]
  def change
    add_column :journeys, :passed_images_count, :integer
  end
end
