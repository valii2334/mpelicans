class RemoveLatLongFromJourney < ActiveRecord::Migration[7.0]
  def change
    remove_column :journeys, :lat, :string
    remove_column :journeys, :long, :string
  end
end
