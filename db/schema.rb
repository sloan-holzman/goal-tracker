# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180114182440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitions", force: :cascade do |t|
    t.bigint "group_id"
    t.date "start_date", default: "2017-11-28"
    t.date "end_date", default: "2017-11-28"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "metric_name"
    t.string "metric_unit"
    t.index ["group_id"], name: "index_competitions_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "private", default: false, null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_invitations_on_group_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "group_id"
    t.boolean "admin", default: false, null: false
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.integer "target", default: 5
    t.boolean "good", default: true
    t.string "duration", default: "Week"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.date "start_date", default: "2017-11-28"
    t.date "last_day_undone", default: "2017-12-27"
    t.date "last_week_undone", default: "2017-12-27"
    t.index ["user_id"], name: "index_metrics_on_user_id"
  end

  create_table "performances", force: :cascade do |t|
    t.date "date"
    t.integer "count", default: 0
    t.boolean "entered", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "metric_id"
    t.index ["metric_id"], name: "index_performances_on_metric_id"
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_requests_on_group_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "reminder", default: true
    t.string "reminder_frequency", default: "Weekly"
    t.string "reminder_day", default: "Thursday"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.date "last_date_created"
    t.date "last_date_entered"
  end

  create_table "weeks", force: :cascade do |t|
    t.date "date"
    t.integer "total", default: 0
    t.bigint "metric_id"
    t.index ["metric_id"], name: "index_weeks_on_metric_id"
  end

  add_foreign_key "competitions", "groups"
  add_foreign_key "invitations", "groups"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "metrics", "users"
  add_foreign_key "performances", "metrics"
  add_foreign_key "requests", "groups"
  add_foreign_key "requests", "users"
  add_foreign_key "weeks", "metrics"
end
