class AddPublicViewable < ActiveRecord::Migration
  def self.up
    add_column :projects, :public_viewable, :boolean, :default => false
  end

  def self.down
    remove_column :projects, :public_viewable
  end
end
