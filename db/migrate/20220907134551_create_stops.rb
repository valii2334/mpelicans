class CreateStops < ActiveRecord::Migration[7.0]
  def change
    create_table :stops do |t|
      t.string :title
      t.string :description
      t.string :plus_code
      t.integer :journey_id

      t.timestamps
    end
  end
end
