class CreateJourneys < ActiveRecord::Migration[7.0]
  def change
    create_table :journeys do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :start_plus_code, null: false
      t.integer :access_type, default: 0, null: false
      t.boolean :accepts_recommendations, default: false, null: false
      t.integer :user_id, null: false
      t.string :access_code, null: false

      t.timestamps
    end
  end
end
