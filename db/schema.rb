# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_31_134130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pull_requests", force: :cascade do |t|
    t.bigint "github_id", null: false
    t.integer "number", null: false
    t.string "state", null: false
    t.boolean "locked", null: false
    t.text "title", null: false
    t.text "body"
    t.datetime "closed_at"
    t.datetime "merged_at"
    t.boolean "draft", null: false
    t.boolean "merged", null: false
    t.string "node_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["github_id"], name: "index_pull_requests_on_github_id", unique: true
  end

  create_table "review_requests", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "owner_id"
    t.bigint "pull_request_id", null: false
    t.string "event_type"
    t.bigint "reviewer_id", null: false
    t.index ["owner_id"], name: "index_review_requests_on_owner_id"
    t.index ["pull_request_id"], name: "index_review_requests_on_pull_request_id"
    t.index ["reviewer_id"], name: "index_review_requests_on_reviewer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "login", null: false
    t.string "node_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "github_id", null: false
    t.index ["github_id"], name: "index_users_on_github_id", unique: true
  end

  add_foreign_key "review_requests", "pull_requests"
  add_foreign_key "review_requests", "users", column: "owner_id"
  add_foreign_key "review_requests", "users", column: "reviewer_id"
end
