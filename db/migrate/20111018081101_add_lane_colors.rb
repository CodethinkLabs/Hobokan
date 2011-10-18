class AddLaneColors < ActiveRecord::Migration
  def self.up
    add_column :lanes, :background_color, :string
    add_column :lanes, :color, :string
  end

  def self.down
    remove_column :lanes, :background_color
    remove_column :lanes, :color
  end
end
