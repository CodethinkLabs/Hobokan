# encoding: utf-8

class Lane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title         :string
    position      :integer
    background_color :string
    color         :string, :default => '#000000'
    timestamps
  end

  children :items
  acts_as_list :scope => :project
  belongs_to :project
  has_many :items, :order => "position ASC"

  set_default_order "position ASC"
  validates_length_of :title, :within => 4..50, :too_long => "pick a shorter name", :too_short => "pick a longer name"

  scope :visible, :conditions => "position > '0'"
  scope :invisible, :conditions => "position <= '0'"

  def name
    title
  end

  def milestones
    return self.project.milestones
  end

  # --- Permissions --- #

  def create_permitted?
    logger.debug("Lane#create_permitted? #{ProjectMember.admin_memberships.inspect} project_id: #{project_id}")
    project.project_members.count == 0 || ProjectMember.admin_memberships.include?(project_id)
  end

  def update_permitted?
    logger.debug("Lane#update_permitted? #{ProjectMember.admin_memberships.inspect} project_id: #{project_id}")
    ProjectMember.admin_memberships.include?(project_id)
  end

  def destroy_permitted?
    ProjectMember.admin_memberships.include?(project_id)
  end

  def view_permitted?(field)
    logger.debug("Lane#view_permitted? #{ProjectMember.view_memberships.inspect} project_id: #{project_id}")
    project.project_members.count == 0 || ProjectMember.view_memberships.include?(project_id)
  end

end
