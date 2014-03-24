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

ActiveRecord::Schema.define(version: 20140119100000) do

  create_table "movie_logs", force: true do |t|
    t.integer  "movie_id",       null: false
    t.integer  "view_counter",   null: false
    t.integer  "mylist_counter", null: false
    t.integer  "comment_num",    null: false
    t.datetime "created_at",     null: false
  end

  add_index "movie_logs", ["movie_id"], name: "index_movie_logs_on_movie_id", using: :btree

  create_table "movie_logs_tags", id: false, force: true do |t|
    t.integer  "movie_log_id", null: false
    t.integer  "tag_id",       null: false
    t.datetime "created_at"
  end

  add_index "movie_logs_tags", ["movie_log_id"], name: "index_movie_logs_tags_on_movie_log_id", using: :btree
  add_index "movie_logs_tags", ["tag_id"], name: "index_movie_logs_tags_on_tag_id", using: :btree

  create_table "movies", force: true do |t|
    t.string   "video_id"
    t.integer  "thread_id"
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.string   "thumbnail_url"
    t.datetime "publish_date"
    t.integer  "length"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movies", ["thread_id"], name: "index_movies_on_thread_id", unique: true, using: :btree

  create_table "mylists", force: true do |t|
    t.integer  "mylist_id"
    t.string   "creator"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mylists", ["mylist_id"], name: "index_mylists_on_mylist_id", unique: true, using: :btree

  create_table "mylists_movies", id: false, force: true do |t|
    t.integer "mylist_id", null: false
    t.integer "movie_id",  null: false
  end

  add_index "mylists_movies", ["movie_id"], name: "index_mylists_movies_on_movie_id", using: :btree
  add_index "mylists_movies", ["mylist_id"], name: "index_mylists_movies_on_mylist_id", using: :btree

  create_table "part_one_movies", force: true do |t|
    t.string   "video_id"
    t.text     "mylist_references"
    t.datetime "publish_date"
    t.integer  "series_mylist_id"
    t.boolean  "has_retrieved_series_mylist"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "part_one_movies", ["video_id"], name: "index_part_one_movies_on_video_id", unique: true, using: :btree

  create_table "rankings", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string "text", limit: 40
  end

  add_index "tags", ["text"], name: "index_tags_on_text", unique: true, using: :btree

end
