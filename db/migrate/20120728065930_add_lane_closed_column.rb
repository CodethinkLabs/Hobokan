class AddLaneClosedColumn < ActiveRecord::Migration
  def self.up
    add_column :lanes, :closed, :boolean, :default => false
  end

  def self.down
    remove_column :lanes, :closed
  end
end
