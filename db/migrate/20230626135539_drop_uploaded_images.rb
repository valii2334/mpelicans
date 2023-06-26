class DropUploadedImages < ActiveRecord::Migration[7.0]
  def change
    drop_table :uploaded_images
  end
end
