class InitializeDatabase < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :crypted_password, :limit => 40
      t.string   :salt, :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :name
      t.string   :email_address
      t.boolean  :administrator, :default => false
      t.string   :role
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :state, :default => "invited"
      t.datetime :key_timestamp
    end
    add_index :users, [:state]

    create_table :items do |t|
      t.date     :start_date
      t.date     :end_date
      t.string   :title
      t.text     :text
      t.text     :result
      t.boolean  :doable
      t.integer  :position
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :lane_id
      t.integer  :project_id
      t.integer  :milestone_id
      t.string   :state, :default => "normal"
      t.datetime :key_timestamp
    end
    add_index :items, [:user_id]
    add_index :items, [:lane_id]
    add_index :items, [:project_id]
    add_index :items, [:milestone_id]
    add_index :items, [:state]

    create_table :lanes do |t|
      t.string   :title
      t.string   :background_color
      t.string   :color, :default => "#000000"
      t.boolean  :todo, :default => true
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :position
      t.integer  :project_id
    end
    add_index :lanes, [:project_id]

    create_table :projects do |t|
      t.string   :name
      t.text     :details
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :state, :default => "running"
      t.datetime :key_timestamp
    end
    add_index :projects, [:state]

    create_table :milestones do |t|
      t.string   :name
      t.date     :date
      t.text     :description
      t.string   :background_color
      t.string   :color, :default => "#000000"
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :project_id
    end
    add_index :milestones, [:project_id]

    create_table :comments do |t|
      t.text     :detail
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :item_id
    end
    add_index :comments, [:user_id]
    add_index :comments, [:item_id]

    create_table :item_assignments do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :project_member_id
      t.integer  :item_id
    end
    add_index :item_assignments, [:project_member_id]
    add_index :item_assignments, [:item_id]

    create_table :project_members do |t|
      t.boolean  :administrator, :default => true
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :project_id
      t.integer  :user_id
    end
    add_index :project_members, [:project_id]
    add_index :project_members, [:user_id]

    create_table :snapshots do |t|
      t.integer :count
      t.date    :date
      t.integer :lane_id
      t.integer :milestone_id
    end
    add_index :snapshots, [:lane_id]
    add_index :snapshots, [:milestone_id]
  end

  def self.down
    drop_table :users
    drop_table :items
    drop_table :lanes
    drop_table :projects
    drop_table :milestones
    drop_table :comments
    drop_table :item_assignments
    drop_table :project_members
    drop_table :snapshots
  end
end
