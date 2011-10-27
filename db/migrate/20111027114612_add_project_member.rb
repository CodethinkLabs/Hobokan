class AddProjectMember < ActiveRecord::Migration
  def self.up
    drop_table :item_users

    create_table :item_project_members do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :project_member_id
      t.integer  :item_id
    end
    add_index :item_project_members, [:project_member_id]
    add_index :item_project_members, [:item_id]

    create_table :project_members do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :project_id
      t.integer  :user_id
    end
    add_index :project_members, [:project_id]
    add_index :project_members, [:user_id]
  end

  def self.down
    create_table "item_users", :force => true do |t|
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.integer   "user_id"
      t.integer   "item_id"
    end

    add_index "item_users", ["item_id"], :name => "index_item_users_on_item_id"
    add_index "item_users", ["user_id"], :name => "index_item_users_on_user_id"

    drop_table :item_project_members
    drop_table :project_members
  end
end
