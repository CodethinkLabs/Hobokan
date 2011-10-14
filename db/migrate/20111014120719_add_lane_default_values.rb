class AddLaneDefaultValues < ActiveRecord::Migration
  def self.up
    change_column :lanes, :max_items, :integer, :default => 25
    change_column :lanes, :warn_limit, :integer, :default => 10
    change_column :lanes, :urgent_limit, :integer, :default => 10
    change_column :lanes, :dashboard, :boolean, :default => false
  end

  def self.down
    change_column :lanes, :max_items, :integer
    change_column :lanes, :warn_limit, :integer
    change_column :lanes, :urgent_limit, :integer
    change_column :lanes, :dashboard, :boolean
  end
end
