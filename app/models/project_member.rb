class ProjectMember < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # Used by the Hobo permissions methods. Returns a list of
  # the project ids of which the current user is a member
  def self.memberships
    Thread.current[:memberships]
  end

  def self.memberships=(memberships)
    Thread.current[:memberships] = memberships
  end

  # Used by the Hobo permissions methods. Returns a list of
  # the project ids of which the current user is a member
  # with adminstrator priviledges
  def self.admin_memberships
    Thread.current[:admin_memberships]
  end

  def self.admin_memberships=(admin_memberships)
    Thread.current[:admin_memberships] = admin_memberships
  end

  fields do
    administrator :boolean, :default => false
    timestamps
  end

  belongs_to :project
  belongs_to :user

  def name
    user.name
  end

  # --- Permissions --- #

  def create_permitted?
    project.nil? ||
    project.project_members.count == 0 ||
    ProjectMember.admin_memberships.include?(project_id)
  end

  def update_permitted?
    ProjectMember.admin_memberships.include?(project_id)
  end

  def destroy_permitted?
    ProjectMember.admin_memberships.include?(project_id)
  end

  def view_permitted?(field)
    true
  end

end
