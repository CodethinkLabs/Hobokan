class ProjectMember < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end

  has_many :items, :through => :item_project_members
  has_many :item_project_members
  belongs_to :project
  belongs_to :user

  def name
    user.name
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
