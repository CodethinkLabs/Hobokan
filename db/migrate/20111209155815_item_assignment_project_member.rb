class ItemAssignmentProjectMember < ActiveRecord::Migration
  def self.up
    add_column :item_assignments, :project_member_id, :integer
    remove_column :item_assignments, :user_id

    remove_index :item_assignments, :name => :index_item_assignments_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :item_assignments, [:project_member_id]
  end

  def self.down
    remove_column :item_assignments, :project_member_id
    add_column :item_assignments, :user_id, :integer

    remove_index :item_assignments, :name => :index_item_assignments_on_project_member_id rescue ActiveRecord::StatementInvalid
    add_index :item_assignments, [:user_id]
  end
end
