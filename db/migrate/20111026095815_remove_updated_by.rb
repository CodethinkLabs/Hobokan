class RemoveUpdatedBy < ActiveRecord::Migration
  def self.up
    remove_column :items, :updated_by
  end

  def self.down
    add_column :items, :updated_by, :string
  end
end
