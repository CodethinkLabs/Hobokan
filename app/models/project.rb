# encoding: utf-8

class Project < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    details :markdown
    timestamps
  end

  set_search_columns :name, :details

  lifecycle do
    state :running, :default => :true
    state :completed

    transition :archive, { :running => :completed } ,  :available_to => "User.administrator"
    transition :reopen, { :completed => :running } ,  :available_to => "User.administrator"
  end

  scope :active, :conditions => "state = 'running'"

  children :lanes
  children :project_members

  has_many :lanes, :order => :position, :dependent => :destroy, :accessible => true
  has_many :items, :dependent => :destroy
  has_many :project_members, :accessible => true
  has_many :users, :through => :project_members
  has_many :milestones, :accessible => true

  validates_length_of :name, :within => 4..50, :too_long => "pick a shorter name", :too_short => "pick a longer name"

  validate :lane_present

  def lane_present
    logger.debug("Project#lane_present lanes: #{lanes.inspect}")
    errors.add :lanes, 'you must enter at least one lane' if lanes.nil? || lanes.length == 0
  end

  def versions
    v = Version.arel_table
    #this is a nasty hack - item.position changes so often it clutters the log - so only take changes with an "e" in the field!?
    return Version.where(:versioned_id => items).where(v[:modifications].matches("%e%")).order("created_at DESC").limit(50)
  end


  # --- Permissions --- #

  def create_permitted?
    logger.debug("Project#create_permitted? #{acting_user.signed_up?} project_id: #{id}")
    acting_user.signed_up?
  end

  def update_permitted?
    logger.debug("Project#update_permitted? #{ProjectMember.admin_memberships.include?(id)} project_id: #{id}")
    ProjectMember.admin_memberships.include?(id)
  end

  def destroy_permitted?
    logger.debug("Project#destroy_permitted? #{ProjectMember.admin_memberships.include?(id)} project_id: #{id}")
    ProjectMember.admin_memberships.include?(id)
  end

  def view_permitted?(field)
    logger.debug("Project#view_permitted? #{ProjectMember.view_memberships.include?(id)} project_id: #{id}")
    ProjectMember.view_memberships.include?(id)
  end

end
