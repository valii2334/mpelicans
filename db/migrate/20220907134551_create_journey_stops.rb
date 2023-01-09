class CreateJourneyStops < ActiveRecord::Migration[7.0]
  def change
    create_table :journey_stops do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :plus_code, null: false
      t.integer :journey_id, null: false

      t.timestamps
    end
  end
end
