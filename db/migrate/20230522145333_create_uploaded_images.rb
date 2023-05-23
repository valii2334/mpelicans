class CreateUploadedImages < ActiveRecord::Migration[7.0]
  def change
    create_table :uploaded_images do |t|
      t.integer :journey_stop_id, null: false
      t.string :s3_key, null: false

      t.timestamps
    end

    add_index :uploaded_images, :journey_stop_id
  end
end
