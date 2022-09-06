class CreateJourneys < ActiveRecord::Migration[7.0]
  def change
    create_table :journeys do |t|
      t.string :title
      t.text :description
      t.string :start_plus_code
      t.integer :status, default: 0
      t.integer :access_type, default: 0
      t.boolean :accepts_recommendations, default: false
      t.integer :user_id
      t.string :access_code
      
      t.timestamps
    end
  end
end
