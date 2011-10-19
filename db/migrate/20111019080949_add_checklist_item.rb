class AddChecklistItem < ActiveRecord::Migration
  def self.up
    create_table :checklist_items do |t|
      t.string   :text
      t.boolean  :done
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :item_id
    end
    add_index :checklist_items, [:item_id]
  end

  def self.down
    drop_table :checklist_items
  end
end
