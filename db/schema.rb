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

ActiveRecord::Schema[7.1].define(version: 2025_10_20_020256) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "appointment_services", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.bigint "service_id", null: false
    t.integer "price"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_appointment_services_on_appointment_id"
    t.index ["service_id"], name: "index_appointment_services_on_service_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.date "date"
    t.text "details"
    t.time "start_time"
    t.time "finish_time"
    t.bigint "user_id", null: false
    t.bigint "professional_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["professional_id"], name: "index_appointments_on_professional_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "professional_services", force: :cascade do |t|
    t.bigint "professional_id", null: false
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price"
    t.index ["professional_id"], name: "index_professional_services_on_professional_id"
    t.index ["service_id"], name: "index_professional_services_on_service_id"
  end

  create_table "professionals", force: :cascade do |t|
    t.string "name"
    t.time "start_at"
    t.time "finish_at"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "gender"
    t.integer "role"
    t.string "number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointment_services", "appointments"
  add_foreign_key "appointment_services", "services"
  add_foreign_key "appointments", "professionals"
  add_foreign_key "appointments", "users"
  add_foreign_key "professional_services", "professionals"
  add_foreign_key "professional_services", "services"
end
