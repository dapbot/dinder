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

ActiveRecord::Schema.define(version: 20150108043656) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clicks", force: true do |t|
    t.integer  "user_id"
    t.integer  "dinder_search_id"
    t.string   "clickable_type"
    t.integer  "clickable_id"
    t.string   "purpose"
    t.integer  "yelp_restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dinder_searches", force: true do |t|
    t.string   "lat_lng"
    t.text     "no_restaurants",  default: [], array: true
    t.text     "yes_restaurants", default: [], array: true
    t.string   "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "instagram_photos", force: true do |t|
    t.integer  "yelp_restaurant_id"
    t.text     "low_resolution_url"
    t.text     "medium_resolution_url"
    t.text     "high_resolution_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opening_periods", force: true do |t|
    t.integer  "openable_id"
    t.integer  "day"
    t.integer  "opens_at"
    t.integer  "closes_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "openable_type"
  end

  create_table "photos", force: true do |t|
    t.integer  "photographable_id"
    t.text     "low_resolution_url"
    t.text     "medium_resolution_url"
    t.text     "high_resolution_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
    t.string   "photographable_type"
    t.boolean  "ignore",                default: false
  end

  create_table "restaurant_tags", force: true do |t|
    t.integer  "taggable_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "taggable_type"
  end

  create_table "restaurants", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "phone_number"
    t.text     "website"
    t.float    "dinder_score"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "suburb"
    t.integer  "photo_1_id"
    t.integer  "photo_2_id"
    t.integer  "photo_3_id"
  end

  create_table "searches", force: true do |t|
    t.boolean  "open_now"
    t.datetime "open_at"
    t.string   "lat_lng"
    t.integer  "cheaper_than"
    t.integer  "fancier_than"
    t.text     "not_cuisines", default: [], array: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shortlistings", force: true do |t|
    t.integer  "yelp_restaurant_id"
    t.integer  "dinder_search_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "clean_name"
    t.string   "tag_type"
    t.boolean  "ignore",     default: false
  end

  create_table "unwanted_restaurant_tags", force: true do |t|
    t.integer  "yelp_restaurant_id"
    t.integer  "dinder_search_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "urbanspoon_restaurants", force: true do |t|
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
    t.integer  "urbanspoon_ranking"
    t.string   "yelp_business_id"
    t.datetime "yelp_last_fetched"
    t.integer  "review_count"
    t.integer  "vote_count"
    t.integer  "restaurant_id"
    t.integer  "photo_1_id"
    t.integer  "photo_2_id"
    t.integer  "photo_3_id"
  end

  create_table "users", force: true do |t|
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.boolean  "ever_swiped_yes",     default: false
    t.boolean  "ever_swiped_no",      default: false
  end

  create_table "yelp_restaurants", force: true do |t|
    t.string   "yelp_id"
    t.string   "name"
    t.string   "address_street"
    t.string   "address_suburb"
    t.string   "address_state"
    t.string   "address_post_code"
    t.string   "phone_number"
    t.text     "website"
    t.float    "rating"
    t.integer  "review_count"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "fetched_at"
    t.integer  "price"
    t.boolean  "take_away"
    t.boolean  "good_for_groups"
    t.boolean  "good_for_children"
    t.integer  "noise_level"
    t.string   "alcohol"
    t.boolean  "reservations"
    t.text     "photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ambience"
    t.datetime "instagram_photos_fetched_at"
    t.float    "dinder_score"
    t.datetime "yelp_photos_last_fetched_at"
    t.integer  "restaurant_id"
    t.integer  "photo_1_id"
    t.integer  "photo_2_id"
    t.integer  "photo_3_id"
  end

end
