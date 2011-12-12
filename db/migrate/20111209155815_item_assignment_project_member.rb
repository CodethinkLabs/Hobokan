class ActiveRecord::Base
  def raw_update(query)
    self.class.connection.execute(query)
  end
end

class ItemAssignmentProjectMember < ActiveRecord::Migration
  def self.up
    temp = {}
    ItemAssignment.all.each do |assignment|
      member = ProjectMember.where(:user_id => assignment.user_id).where(:project_id =>assignment.item.project)
      temp[assignment.id] = member[0].id
    end

    add_column :item_assignments, :project_member_id, :integer
    remove_column :item_assignments, :user_id

    remove_index :item_assignments, :name => :index_item_assignments_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :item_assignments, [:project_member_id]

    ItemAssignment.all.each do |assignment|
      assignment.raw_update("UPDATE item_assignments SET project_member_id = #{temp[assignment.id]} where id = #{assignment.id}")
    end
  end

  def self.down
    remove_column :item_assignments, :project_member_id
    add_column :item_assignments, :user_id, :integer

    remove_index :item_assignments, :name => :index_item_assignments_on_project_member_id rescue ActiveRecord::StatementInvalid
    add_index :item_assignments, [:user_id]
  end
end
