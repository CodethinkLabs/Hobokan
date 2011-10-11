class InitialDatabase < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.datetime :entry_time
      t.datetime :leave_time
      t.integer  :duration
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :lane_id
      t.integer  :item_id
      t.integer  :user_id
    end
    add_index :statistics, [:lane_id]
    add_index :statistics, [:item_id]
    add_index :statistics, [:user_id]

    create_table :lanes do |t|
      t.string   :title
      t.integer  :max_items
      t.integer  :position
      t.string   :type
      t.boolean  :counts_wip
      t.integer  :warn_limit
      t.integer  :urgent_limit
      t.boolean  :dashboard
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :project_id
      t.integer  :super_lane_id
    end
    add_index :lanes, [:project_id]
    add_index :lanes, [:super_lane_id]

    create_table :projects do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :items do |t|
      t.date     :start_date
      t.date     :end_date
      t.string   :title
      t.text     :text
      t.float    :estimation
      t.integer  :position
      t.integer  :wip_total
      t.datetime :current_lane_entry
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :lane_id
      t.integer  :last_editor_id
      t.integer  :owner_id
    end
    add_index :items, [:lane_id]
    add_index :items, [:owner_id]
    add_index :items, [:last_editor_id]

    create_table :history_entries do |t|
      t.string   :action
      t.text     :delta
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :item_id
      t.string   :trigger_type
      t.integer  :trigger_id
    end
    add_index :history_entries, [:item_id]
    add_index :history_entries, [:trigger_type, :trigger_id]
  end

  def self.down
    drop_table :statistics
    drop_table :lanes
    drop_table :projects
    drop_table :items
    drop_table :history_entries
  end
end
