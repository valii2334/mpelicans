class AddViewsCountToJourneys < ActiveRecord::Migration[7.0]
  def change
    add_column :journeys,      :views_count, :integer, default: 0
    add_column :journey_stops, :views_count, :integer, default: 0
  end
end
