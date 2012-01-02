class ItemAssignment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end

  belongs_to :project_member
  belongs_to :item

  before_save :log_assignment

  def log_assignment
    item.result = project_member.name + " assigned" + "\n" + item.result.to_s
    item.save
  end

  # --- Permissions --- #

  def create_permitted?
    ProjectMember.memberships.include?(item.project_id)
  end

  def update_permitted?
    ProjectMember.memberships.include?(item.project_id)
  end

  def destroy_permitted?
    ProjectMember.memberships.include?(item.project_id)
  end

  def view_permitted?(field)
    ProjectMember.view_memberships.include?(item.project_id)
  end

end
