class AddLatAndLong < ActiveRecord::Migration[7.0]
  def change
    add_column :journeys, :lat, :string
    add_column :journeys, :long, :string

    add_column :journey_stops, :lat, :string
    add_column :journey_stops, :long, :string
  end
end
