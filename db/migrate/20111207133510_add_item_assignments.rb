class AddItemAssignments < ActiveRecord::Migration
  def self.up
    drop_table :checklist_items
    drop_table :item_project_members

    create_table :item_assignments do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :item_id
    end
    add_index :item_assignments, [:user_id]
    add_index :item_assignments, [:item_id]

    add_column :items, :result, :text

    add_column :projects, :details, :text
    add_column :projects, :state, :string, :default => "running"
    add_column :projects, :key_timestamp, :datetime

    add_index :projects, [:state]
  end

  def self.down
    remove_column :items, :result

    remove_column :projects, :details
    remove_column :projects, :state
    remove_column :projects, :key_timestamp

    create_table "checklist_items", :force => true do |t|
      t.string   "text"
      t.boolean  "done"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "item_id"
    end

    add_index "checklist_items", ["item_id"], :name => "index_checklist_items_on_item_id"

    create_table "item_project_members", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "project_member_id"
      t.integer  "item_id"
    end

    add_index "item_project_members", ["item_id"], :name => "index_item_project_members_on_item_id"
    add_index "item_project_members", ["project_member_id"], :name => "index_item_project_members_on_project_member_id"

    drop_table :item_assignments

    remove_index :projects, :name => :index_projects_on_state rescue ActiveRecord::StatementInvalid
  end
end
