class AddPerProjectPermissions < ActiveRecord::Migration
  def self.up
    add_column :projects, :per_project_permissions, :boolean, :default => false

    add_column :project_members, :administrator, :boolean, :default => false
  end

  def self.down
    remove_column :projects, :per_project_permissions

    remove_column :project_members, :administrator
  end
end
