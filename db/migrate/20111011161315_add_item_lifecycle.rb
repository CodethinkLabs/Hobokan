class AddItemLifecycle < ActiveRecord::Migration
  def self.up
    add_column :items, :state, :string, :default => "normal"
    add_column :items, :key_timestamp, :datetime

    add_index :lanes, [:type]

    add_index :items, [:state]
  end

  def self.down
    remove_column :items, :state
    remove_column :items, :key_timestamp

    remove_index :lanes, :name => :index_lanes_on_type rescue ActiveRecord::StatementInvalid

    remove_index :items, :name => :index_items_on_state rescue ActiveRecord::StatementInvalid
  end
end
