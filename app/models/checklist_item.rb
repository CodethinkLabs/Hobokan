class ChecklistItem < ActiveRecord::Base

  hobo_model # Don't put anything above this
  # versioned

  fields do
    text :string
    done :boolean
    timestamps
  end

  belongs_to :item

  # --- Permissions --- #

  def create_permitted?
    item.lane.project.project_member?(acting_user)
  end

  def update_permitted?
    item.lane.project.project_member?(acting_user)
  end

  def destroy_permitted?
    item.lane.project.project_member?(acting_user)
  end

  def view_permitted?(field)
    true
  end

end
