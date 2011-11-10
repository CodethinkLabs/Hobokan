# encoding: utf-8

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
    ProjectMember.memberships.include?(project_id)
  end

  def update_permitted?
    ProjectMember.memberships.include?(project_id)
  end

  def destroy_permitted?
    ProjectMember.memberships.include?(project_id)
  end

  def view_permitted?(field)
    true
  end

end
