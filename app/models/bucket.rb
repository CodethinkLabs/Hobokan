class Bucket < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    description :string
    done :boolean, :default => false
    background_color :string
    color         :string, :default => '#000000'
    timestamps
  end

  belongs_to :project
  has_many :items

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
    ProjectMember.view_memberships.include?(project_id)
  end

end
