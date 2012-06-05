class ProjectMember < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # Used by the Hobo permissions methods. Returns a list of
  # the project ids of which the current user is a member
  def self.memberships
    Thread.current[:memberships]
  end

  def self.memberships=(memberships)
    logger.debug("ProjectMember#memberships= #{memberships.inspect}")
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

  # Used by the Hobo permissions methods. Returns a list of
  # the project ids of which the current user is a member
  # with view-only rights
  def self.view_memberships
    Thread.current[:view_memberships]
  end

  def self.view_memberships=(view_memberships)
    Thread.current[:view_memberships] = view_memberships
  end

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
