class AddUpdatedBy < ActiveRecord::Migration
  def self.up
    add_column :items, :updated_by, :string
  end

  def self.down
    remove_column :items, :updated_by
  end
end
