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

ActiveRecord::Schema.define(version: 20210518140812) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "overwork_request"
    t.boolean "next_day"
    t.text "work_content"
    t.integer "superior_confirm"
    t.integer "over_work_allow"
    t.boolean "over_work_allow_check"
    t.integer "kintai_change_confirm"
    t.integer "kintai_change_allow"
    t.boolean "kintai_change_allow_check"
    t.integer "kintai_month_confirm"
    t.integer "kintai_month_allow"
    t.boolean "kintai_month_allow_check"
    t.datetime "request_start_at"
    t.datetime "request_finish_at"
    t.boolean "request_next_day"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_num"
    t.string "base_name"
    t.string "base_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "affiliation"
    t.datetime "basic_work_time", default: "2021-06-09 23:00:00"
    t.datetime "work_time", default: "2021-06-09 22:30:00"
    t.boolean "superior", default: false
    t.datetime "designates_work_start_time", default: "2021-06-10 00:00:00"
    t.datetime "designates_work_end_time", default: "2021-06-10 09:00:00"
    t.integer "employee_number"
    t.integer "uid"
    t.boolean "work_now"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
