class AddMilestones < ActiveRecord::Migration
  def self.up
    drop_table :checklist_items
    drop_table :checklists
    drop_table :item_project_members

    create_table :milestones do |t|
      t.string   :name
      t.date     :date
      t.string   :background_color
      t.string   :color, :default => "#000000"
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :project_id
    end
    add_index :milestones, [:project_id]

    add_column :items, :milestone_id, :integer

    change_column :project_members, :administrator, :boolean, :default => true

    add_index :items, [:milestone_id]
  end

  def self.down
    remove_column :items, :milestone_id

    change_column :project_members, :administrator, :boolean, :default => false

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

    drop_table :milestones

    remove_index :items, :name => :index_items_on_milestone_id rescue ActiveRecord::StatementInvalid
  end
end
