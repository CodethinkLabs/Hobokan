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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111014120719) do

  create_table "history_entries", :force => true do |t|
    t.string   "action"
    t.text     "delta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.string   "trigger_type"
    t.integer  "trigger_id"
  end

  add_index "history_entries", ["item_id"], :name => "index_history_entries_on_item_id"
  add_index "history_entries", ["trigger_type", "trigger_id"], :name => "index_history_entries_on_trigger_type_and_trigger_id"

  create_table "items", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "title"
    t.text     "text"
    t.float    "estimation"
    t.integer  "position"
    t.integer  "wip_total"
    t.datetime "current_lane_entry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lane_id"
    t.integer  "last_editor_id"
    t.string   "state",              :default => "normal"
    t.datetime "key_timestamp"
    t.integer  "user_id"
  end

  add_index "items", ["lane_id"], :name => "index_items_on_lane_id"
  add_index "items", ["last_editor_id"], :name => "index_items_on_last_editor_id"
  add_index "items", ["state"], :name => "index_items_on_state"
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "lanes", :force => true do |t|
    t.string   "title"
    t.integer  "max_items",     :default => 25
    t.integer  "position"
    t.string   "type"
    t.boolean  "counts_wip"
    t.integer  "warn_limit",    :default => 10
    t.integer  "urgent_limit",  :default => 10
    t.boolean  "dashboard",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "super_lane_id"
  end

  add_index "lanes", ["project_id"], :name => "index_lanes_on_project_id"
  add_index "lanes", ["super_lane_id"], :name => "index_lanes_on_super_lane_id"
  add_index "lanes", ["type"], :name => "index_lanes_on_type"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statistics", :force => true do |t|
    t.datetime "entry_time"
    t.datetime "leave_time"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lane_id"
    t.integer  "item_id"
    t.integer  "user_id"
  end

  add_index "statistics", ["item_id"], :name => "index_statistics_on_item_id"
  add_index "statistics", ["lane_id"], :name => "index_statistics_on_lane_id"
  add_index "statistics", ["user_id"], :name => "index_statistics_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "invited"
    t.datetime "key_timestamp"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

end
