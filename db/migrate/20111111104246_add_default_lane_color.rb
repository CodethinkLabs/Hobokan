class AddDefaultLaneColor < ActiveRecord::Migration
  def self.up
    drop_table :item_users
    drop_table :statistics
    drop_table :history_entries

    change_column :lanes, :color, :string, :limit => 255, :default => "#000000"

    # ActiveRecord::Base.logger = Logger.new(STDERR)
    Lane.all.each do |lane|
      if lane.color.blank?
        lane.color = '#000000'
        lane.save
      end
    end
  end

  def self.down
    change_column :lanes, :color, :string

    create_table "item_users", :force => true do |t|
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.integer   "user_id"
      t.integer   "item_id"
    end

    add_index "item_users", ["item_id"], :name => "index_item_users_on_item_id"
    add_index "item_users", ["user_id"], :name => "index_item_users_on_user_id"

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
  end
end
