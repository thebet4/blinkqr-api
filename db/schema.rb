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

ActiveRecord::Schema[8.0].define(version: 2025_06_01_042036) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "analytics", force: :cascade do |t|
    t.bigint "link_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.string "referrer"
    t.string "country"
    t.string "city"
    t.string "device_type"
    t.string "os"
    t.string "browser"
    t.string "browser_version"
    t.string "browser_language"
    t.string "browser_color_depth"
    t.string "browser_screen_resolution"
    t.string "browser_screen_color"
    t.string "browser_screen_width"
    t.string "browser_screen_height"
    t.string "browser_screen_pixel_ratio"
    t.string "browser_screen_dpi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id"], name: "index_analytics_on_link_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "code"
    t.string "origin"
    t.date "expire_date"
    t.integer "total_access"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "refresh_token"
  end

  add_foreign_key "analytics", "links"
  add_foreign_key "links", "users"
end
