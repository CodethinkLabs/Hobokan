class ProjectMember < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    administrator :boolean, :default => false
    timestamps
  end

  has_many :items, :through => :item_project_members
  has_many :item_project_members, :dependent => :destroy

  belongs_to :project
  belongs_to :user

  def name
    user.name
  end

  # --- Permissions --- #

  def create_permitted?
    project.project_members.count == 0 || project.project_admin?(acting_user)
  end

  def update_permitted?
    logger.debug("In update_permitted? #{self.inspect} id: #{id} project: #{project}")
    if project.nil?
      return true
    end

    project.project_admin?(acting_user)
  end

  def destroy_permitted?
    project.project_admin?(acting_user)
  end

  def view_permitted?(field)
    true
  end

end
