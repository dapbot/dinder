# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141109010022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "opening_periods", force: true do |t|
    t.integer  "restaurant_id"
    t.integer  "day"
    t.integer  "opens_at"
    t.integer  "closes_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_tags", force: true do |t|
    t.integer  "restaurant_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurants", force: true do |t|
    t.string   "name"
    t.string   "suburb"
    t.text     "address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "rating"
    t.text     "url"
    t.integer  "price"
    t.string   "urbanspoon_id"
    t.string   "phone_number"
    t.text     "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "opening_hours_last_fetched"
    t.string   "google_place_id"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
