class AddMissingIndexesPaidJourney < ActiveRecord::Migration[7.0]
  def change
    add_index :paid_journeys, [:user_id, :journey_id], unique: true
  end
end
