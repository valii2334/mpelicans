class RemovePlusCode < ActiveRecord::Migration[7.0]
  def change
    remove_column :journeys, :start_plus_code, :string
    remove_column :journey_stops, :plus_code, :string
  end
end
