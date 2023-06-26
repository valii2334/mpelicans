class CreateUploadedImagePolymorphics < ActiveRecord::Migration[7.0]
  def change
    create_table :uploaded_images do |t|
      t.string :s3_key, null: false
      t.references :imageable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
