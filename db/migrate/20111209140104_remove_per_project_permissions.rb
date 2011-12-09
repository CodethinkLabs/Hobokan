class RemovePerProjectPermissions < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string

    remove_column :projects, :per_project_permissions
  end

  def self.down
    remove_column :users, :role

    add_column :projects, :per_project_permissions, :boolean, :default => false
  end
end
