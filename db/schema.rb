# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_01_27_163200) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "database_images", force: :cascade do |t|
    t.binary "data", null: false
    t.string "file_extension", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "journey_stops", force: :cascade do |t|
    t.string "title", null: false
    t.integer "journey_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_processing_status"
    t.integer "passed_images_count"
    t.text "description"
    t.float "lat", null: false
    t.float "long", null: false
    t.integer "views_count", default: 0
    t.string "place_id"
    t.jsonb "image_links", default: {}
    t.index ["journey_id"], name: "index_journey_stops_on_journey_id"
  end

  create_table "journeys", force: :cascade do |t|
    t.string "title", null: false
    t.integer "access_type", default: 0, null: false
    t.boolean "accepts_recommendations", default: false, null: false
    t.integer "user_id", null: false
    t.string "access_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "passed_images_count"
    t.integer "image_processing_status"
    t.text "description"
    t.datetime "latest_journey_stop_added_at", null: false
    t.integer "views_count", default: 0
    t.jsonb "image_links", default: {}
    t.index ["user_id"], name: "index_journeys_on_user_id"
  end

  create_table "map_pins", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "journey_stop_id"
    t.float "lat", null: false
    t.float "long", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "place_id"
    t.index ["journey_stop_id"], name: "index_map_pins_on_journey_stop_id"
    t.index ["user_id", "journey_stop_id"], name: "index_map_pins_on_user_id_and_journey_stop_id", unique: true
    t.index ["user_id"], name: "index_map_pins_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "journey_id"
    t.integer "journey_stop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sender_id", null: false
    t.integer "receiver_id", null: false
    t.boolean "read", default: false, null: false
    t.string "type"
    t.index ["journey_id"], name: "index_notifications_on_journey_id"
    t.index ["journey_stop_id"], name: "index_notifications_on_journey_stop_id"
    t.index ["receiver_id"], name: "index_notifications_on_receiver_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
  end

  create_table "paid_journeys", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "journey_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journey_id"], name: "index_paid_journeys_on_journey_id"
    t.index ["user_id", "journey_id"], name: "index_paid_journeys_on_user_id_and_journey_id", unique: true
    t.index ["user_id"], name: "index_paid_journeys_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_relationships_on_followee_id"
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "uploaded_images", force: :cascade do |t|
    t.string "s3_key", null: false
    t.string "imageable_type", null: false
    t.bigint "imageable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_uploaded_images_on_imageable"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.string "biography"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
