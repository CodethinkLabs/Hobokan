class AddItemProject < ActiveRecord::Migration
  def self.up
    add_column :items, :project_id, :integer

    add_index :items, [:project_id]
  end

  def self.down
    remove_column :items, :project_id

    remove_index :items, :name => :index_items_on_project_id rescue ActiveRecord::StatementInvalid
  end
end
