class Snapshot < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    count :integer
    date :date
  end

  belongs_to :lane
  belongs_to :milestone

  # --- Permissions --- #

  def create_permitted?
    ProjectMember.memberships.include?(lane.project_id)
  end

  def update_permitted?
    ProjectMember.memberships.include?(lane.project_id)
  end

  def destroy_permitted?
    ProjectMember.memberships.include?(lane.project_id)
  end

  def view_permitted?(field)
    ProjectMember.view_memberships.include?(lane.project_id)
  end

end
