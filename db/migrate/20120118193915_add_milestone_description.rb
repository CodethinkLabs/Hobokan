class AddMilestoneDescription < ActiveRecord::Migration
  def self.up
    drop_table :checklist_items
    drop_table :checklists
    drop_table :item_project_members

    add_column :milestones, :description, :text
  end

  def self.down
    remove_column :milestones, :description

    create_table "checklist_items", :force => true do |t|
      t.string    "text"
      t.boolean   "done"
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.integer   "item_id"
    end

    add_index "checklist_items", ["item_id"], :name => "index_checklist_items_on_item_id"

    create_table "checklists", :force => true do |t|
      t.string    "text"
      t.boolean   "done"
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.integer   "item_id"
    end

    add_index "checklists", ["item_id"], :name => "index_checklists_on_item_id"

    create_table "item_project_members", :force => true do |t|
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.integer   "project_member_id"
      t.integer   "item_id"
    end

    add_index "item_project_members", ["item_id"], :name => "index_item_project_members_on_item_id"
    add_index "item_project_members", ["project_member_id"], :name => "index_item_project_members_on_project_member_id"
  end
end
