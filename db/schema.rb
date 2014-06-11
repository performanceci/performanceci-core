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

ActiveRecord::Schema.define(version: 20140608011422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "build_endpoints", force: true do |t|
    t.integer  "endpoint_id"
    t.integer  "build_id"
    t.text     "data"
    t.float    "response_time"
    t.integer  "score"
    t.text     "screenshot"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.json     "full_results"
    t.json     "status_codes"
    t.json     "test_errors"
    t.integer  "request_count"
  end

  create_table "builds", force: true do |t|
    t.string   "ref"
    t.string   "before"
    t.string   "after"
    t.integer  "repository_id"
    t.text     "message"
    t.text     "payload"
    t.text     "url"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "build_status"
    t.string   "docker_image_id"
    t.string   "docker_container_id"
    t.text     "compare"
    t.integer  "percent_done",        default: 0
    t.string   "status"
    t.float    "average_response"
    t.float    "percent_change",      default: 0.0
    t.text     "error_message"
  end

  create_table "endpoints", force: true do |t|
    t.string   "name"
    t.text     "url"
    t.text     "headers"
    t.integer  "repository_id"
    t.string   "benchmark_type"
    t.integer  "request_count"
    t.integer  "concurrency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order"
    t.float    "max_response_time"
    t.float    "target_response_time"
    t.integer  "duration"
  end

  create_table "repositories", force: true do |t|
    t.string   "name"
    t.string   "full_name"
    t.text     "url"
    t.integer  "github_id"
    t.integer  "user_id"
    t.string   "hook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "github_id"
    t.string   "github_oauth_token"
    t.string   "gravatar_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
