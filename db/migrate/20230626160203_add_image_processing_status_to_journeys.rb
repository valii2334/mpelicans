class AddImageProcessingStatusToJourneys < ActiveRecord::Migration[7.0]
  def change
    add_column :journeys, :image_processing_status, :integer
  end
end
