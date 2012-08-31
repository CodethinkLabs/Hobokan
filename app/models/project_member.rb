class ProjectMember < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    administrator :boolean, :default => true
    timestamps
  end

  belongs_to :project
  belongs_to :user

  def name
    user.name
  end

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    true
  end

  def destroy_permitted?
    true
  end

  def view_permitted?(field)
    true
  end

end
