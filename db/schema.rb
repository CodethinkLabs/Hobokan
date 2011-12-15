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

ActiveRecord::Schema.define(:version => 20111215193009) do

  create_table "item_assignments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.integer  "project_member_id"
  end

  add_index "item_assignments", ["item_id"], :name => "index_item_assignments_on_item_id"
  add_index "item_assignments", ["project_member_id"], :name => "index_item_assignments_on_project_member_id"

  create_table "items", :force => true do |t|
    t.date      "start_date"
    t.date      "end_date"
    t.string    "title"
    t.text      "text"
    t.float     "estimation"
    t.integer   "position"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "lane_id"
    t.string    "state",         :default => "normal"
    t.timestamp "key_timestamp"
    t.integer   "project_id"
    t.text      "result"
    t.integer   "milestone_id"
  end

  add_index "items", ["lane_id"], :name => "index_items_on_lane_id"
  add_index "items", ["milestone_id"], :name => "index_items_on_milestone_id"
  add_index "items", ["project_id"], :name => "index_items_on_project_id"
  add_index "items", ["state"], :name => "index_items_on_state"

  create_table "lanes", :force => true do |t|
    t.string    "title"
    t.integer   "position"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "project_id"
    t.string    "background_color"
    t.string    "color",            :default => "#000000"
  end

  add_index "lanes", ["project_id"], :name => "index_lanes_on_project_id"

  create_table "milestones", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.string   "background_color"
    t.string   "color",            :default => "#000000"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "milestones", ["project_id"], :name => "index_milestones_on_project_id"

  create_table "project_members", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "user_id"
    t.boolean  "administrator", :default => true
  end

  add_index "project_members", ["project_id"], :name => "index_project_members_on_project_id"
  add_index "project_members", ["user_id"], :name => "index_project_members_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "details"
    t.string   "state",         :default => "running"
    t.datetime "key_timestamp"
  end

  add_index "projects", ["state"], :name => "index_projects_on_state"

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
    t.string    "role"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

  create_table "versions", :force => true do |t|
    t.integer   "versioned_id"
    t.string    "versioned_type"
    t.integer   "user_id"
    t.string    "user_type"
    t.string    "user_name"
    t.text      "modifications"
    t.integer   "number"
    t.integer   "reverted_from"
    t.string    "tag"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

end
