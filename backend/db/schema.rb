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

ActiveRecord::Schema[8.0].define(version: 2025_06_07_210021) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "conversations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_a_id", null: false
    t.uuid "user_b_id", null: false
    t.integer "messages_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "user_a_deleted"
    t.boolean "user_b_deleted"
    t.index ["user_a_id", "user_b_id"], name: "index_conversations_on_user_a_id_and_user_b_id", unique: true
    t.index ["user_a_id"], name: "index_conversations_on_user_a_id"
    t.index ["user_b_id"], name: "index_conversations_on_user_b_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "conversation_id", null: false
    t.text "content"
    t.string "attachment_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token"
    t.datetime "last_login_at"
    t.index ["authentication_token"], name: "index_users_on_authentication_token"
  end

  add_foreign_key "conversations", "users", column: "user_a_id", on_delete: :cascade
  add_foreign_key "conversations", "users", column: "user_b_id", on_delete: :cascade
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
end
