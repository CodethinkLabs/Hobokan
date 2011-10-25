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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111025124338) do

  create_table "checklist_items", :force => true do |t|
    t.string    "text"
    t.boolean   "done"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "item_id"
  end

  add_index "checklist_items", ["item_id"], :name => "index_checklist_items_on_item_id"

  create_table "history_entries", :force => true do |t|
    t.string    "action"
    t.text      "delta"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "item_id"
    t.string    "trigger_type"
    t.integer   "trigger_id"
  end

  add_index "history_entries", ["item_id"], :name => "index_history_entries_on_item_id"
  add_index "history_entries", ["trigger_type", "trigger_id"], :name => "index_history_entries_on_trigger_type_and_trigger_id"

  create_table "item_users", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "user_id"
    t.integer   "item_id"
  end

  add_index "item_users", ["item_id"], :name => "index_item_users_on_item_id"
  add_index "item_users", ["user_id"], :name => "index_item_users_on_user_id"

  create_table "items", :force => true do |t|
    t.date      "start_date"
    t.date      "end_date"
    t.string    "title"
    t.text      "text"
    t.float     "estimation"
    t.integer   "position"
    t.integer   "wip_total"
    t.timestamp "current_lane_entry"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "lane_id"
    t.integer   "last_editor_id"
    t.string    "state",              :default => "normal"
    t.timestamp "key_timestamp"
  end

  add_index "items", ["lane_id"], :name => "index_items_on_lane_id"
  add_index "items", ["last_editor_id"], :name => "index_items_on_last_editor_id"
  add_index "items", ["state"], :name => "index_items_on_state"

  create_table "lanes", :force => true do |t|
    t.string    "title"
    t.integer   "max_items",        :default => 25
    t.integer   "position"
    t.string    "type"
    t.boolean   "counts_wip"
    t.integer   "warn_limit",       :default => 10
    t.integer   "urgent_limit",     :default => 10
    t.boolean   "dashboard",        :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "project_id"
    t.string    "background_color"
    t.string    "color"
  end

  add_index "lanes", ["project_id"], :name => "index_lanes_on_project_id"

  create_table "projects", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "statistics", :force => true do |t|
    t.timestamp "entry_time"
    t.timestamp "leave_time"
    t.integer   "duration"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "lane_id"
    t.integer   "item_id"
    t.integer   "user_id"
  end

  add_index "statistics", ["item_id"], :name => "index_statistics_on_item_id"
  add_index "statistics", ["lane_id"], :name => "index_statistics_on_lane_id"
  add_index "statistics", ["user_id"], :name => "index_statistics_on_user_id"

  create_table "users", :force => true do |t|
    t.string    "crypted_password",          :limit => 40
    t.string    "salt",                      :limit => 40
    t.string    "remember_token"
    t.timestamp "remember_token_expires_at"
    t.string    "name"
    t.string    "email_address"
    t.boolean   "administrator",                           :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "state",                                   :default => "invited"
    t.timestamp "key_timestamp"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications"
    t.integer  "number"
    t.integer  "reverted_from"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

end
