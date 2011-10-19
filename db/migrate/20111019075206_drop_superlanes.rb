class DropSuperlanes < ActiveRecord::Migration
  def self.up
    remove_column :lanes, :super_lane_id

    remove_index :lanes, :name => :index_lanes_on_type rescue ActiveRecord::StatementInvalid
    remove_index :lanes, :name => :index_lanes_on_super_lane_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :lanes, :super_lane_id, :integer

    add_index :lanes, [:type]
    add_index :lanes, [:super_lane_id]
  end
end
