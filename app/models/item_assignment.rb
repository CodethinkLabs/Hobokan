class ItemAssignment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end

  belongs_to :user
  belongs_to :item

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
    true
  end

end
