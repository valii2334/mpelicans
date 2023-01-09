class CreatePaidJourneys < ActiveRecord::Migration[7.0]
  def change
    create_table :paid_journeys do |t|
      t.integer :user_id, null: false
      t.integer :journey_id, null: false

      t.timestamps
    end
  end
end
