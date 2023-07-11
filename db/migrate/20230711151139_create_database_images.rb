class CreateDatabaseImages < ActiveRecord::Migration[7.0]
  def change
    create_table :database_images do |t|
      t.binary :data, null: false
      t.string :file_extension, null: false

      t.timestamps
    end
  end
end
