class RemoveDescriptionFromJourneyAndJourneyStop < ActiveRecord::Migration[7.0]
  def change
    remove_column :journey_stops, :description, :string
    remove_column :journeys, :description, :string
  end
end
