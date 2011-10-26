class DropHistoryEntries < ActiveRecord::Migration
  def self.up
    drop_table :history_entries
  end

  def self.down
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
