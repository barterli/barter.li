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

ActiveRecord::Schema.define(version: 20140424073445) do

  create_table "alerts", force: true do |t|
    t.integer  "user_id"
    t.integer  "thing_id"
    t.string   "thing_type"
    t.boolean  "is_seen"
    t.string   "reason_type"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "token_secret"
  end

  create_table "barters", force: true do |t|
    t.integer  "user_id"
    t.integer  "notifier_id"
    t.integer  "book_id"
    t.integer  "exchange_book_id"
    t.string   "exchange_items"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "street"
    t.string   "address"
    t.string   "place"
    t.time     "time"
    t.date     "date"
    t.integer  "stage",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", force: true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "isbn_10"
    t.string   "isbn_13"
    t.string   "edition"
    t.integer  "print"
    t.integer  "publication_year"
    t.string   "publication_month"
    t.string   "condition"
    t.integer  "value"
    t.boolean  "status"
    t.integer  "stage"
    t.text     "description"
    t.integer  "visits"
    t.integer  "user_id"
    t.string   "prefered_place"
    t.string   "prefered_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating"
    t.string   "image"
    t.string   "publisher"
    t.string   "goodreads_id"
    t.string   "ext_image_url"
    t.integer  "pages"
    t.string   "language_code"
    t.string   "barter_type"
    t.integer  "location_id"
    t.string   "id_book"
  end

  add_index "books", ["location_id"], name: "book_location_id_ix", using: :btree
  add_index "books", ["user_id"], name: "book_user_id_ix", using: :btree

  create_table "books_tags", force: true do |t|
    t.integer "book_id"
    t.integer "tag_id"
  end

  create_table "books_tags_associations", force: true do |t|
    t.integer "book_id"
    t.integer "tag_id"
  end

  create_table "chat_filters", force: true do |t|
    t.integer  "user_id"
    t.integer  "block_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_groups", force: true do |t|
    t.integer  "user_id"
    t.integer  "chat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chats", force: true do |t|
    t.string   "msg_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "default_settings", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.boolean  "status",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_tracks", force: true do |t|
    t.integer  "user_id"
    t.string   "sent_for"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "is_private",  default: false
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "locality"
    t.string   "name"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "id_location"
  end

  add_index "locations", ["latitude", "longitude"], name: "index_locations_on_latitude_and_longitude", using: :btree

  create_table "members", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
  end

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "msg_from"
    t.integer  "msg_to"
    t.string   "chat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.integer  "notifier_id"
    t.text     "message"
    t.integer  "barter_id"
    t.integer  "parent_id",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_seen",     default: false
    t.integer  "target_id"
    t.integer  "sent_by"
  end

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.text     "body"
    t.string   "title"
    t.integer  "publish_type"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registers", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "register_type"
    t.text     "body"
  end

  create_table "settings", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["user_id"], name: "setting_user_id_ix", using: :btree

  create_table "statics", force: true do |t|
    t.string   "page_name"
    t.text     "body"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_book_visits", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "time_spent"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_feedbacks", force: true do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.string   "issue_url"
    t.text     "message"
    t.string   "title"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_likes", force: true do |t|
    t.integer  "book_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_reviews", force: true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.string   "moderate"
    t.integer  "stars"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "review_user_id"
  end

  create_table "user_shares", force: true do |t|
    t.integer  "user_id"
    t.integer  "shared_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "gender"
    t.integer  "age"
    t.string   "birthday"
    t.string   "anniversary"
    t.string   "occupancy"
    t.string   "marital_status"
    t.string   "mobile"
    t.string   "region"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "street"
    t.string   "address"
    t.string   "pincode"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "accuracy"
    t.string   "altitude"
    t.boolean  "status",                 default: true
    t.string   "payment_status"
    t.boolean  "is_admin",               default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "locality"
    t.string   "place"
    t.string   "authentication_token"
    t.text     "description"
    t.string   "share_token"
    t.string   "profile"
    t.string   "id_user"
    t.string   "ext_image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wish_lists", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "author"
    t.boolean  "in_locality", default: false
    t.boolean  "in_city",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
