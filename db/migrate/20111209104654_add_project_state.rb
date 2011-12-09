class AddProjectState < ActiveRecord::Migration
  def self.up
    add_column :items, :result, :text

    add_column :projects, :details, :text
    add_column :projects, :state, :string, :default => "running"
    add_column :projects, :key_timestamp, :datetime

    add_index :projects, [:state]
  end

  def self.down
    remove_column :items, :result

    remove_column :projects, :details
    remove_column :projects, :state
    remove_column :projects, :key_timestamp

    remove_index :projects, :name => :index_projects_on_state rescue ActiveRecord::StatementInvalid
  end
end
