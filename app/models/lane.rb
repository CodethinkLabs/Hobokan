# encoding: utf-8

class Lane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title         :string
    position      :integer
    background_color :string
    color         :string, :default => '#000000'
    todo          :boolean, :default => true
    timestamps
  end

  children :items
  acts_as_list :scope => :project
  belongs_to :project
  has_many :items, :order => "position DESC"

  set_default_order "position ASC"
  validates_length_of :title, :within => 4..50, :too_long => "pick a shorter name", :too_short => "pick a longer name"

  scope :visible, :conditions => "position > '0'"
  scope :invisible, :conditions => "position <= '0'"

  def self.move_item(current_user, moved_item)
    logger.debug("current user: #{current_user}")
    old_lane = Lane.find(moved_item.lane_id_was)
    lane = moved_item.lane
    target = moved_item.position
    moved_item.user_save(current_user)

    items = Item.where(:lane_id => lane.id).where("state <> 'archived'").order("position DESC")
    position = items.length
    items.each do |item|
      if item != moved_item
        if position == target
          item.position += 1
        else
          item.position = position
        end
        item.user_save(current_user)
      end
      position -= 1
    end

    if old_lane.id != lane.id
      items = Item.where(:lane_id => old_lane.id).where("state <> 'archived'").order("position DESC")
      position = items.length
      items.each do |item|
        item.position = position
        item.user_save(current_user)
        position -= 1
      end
    end
  end

  def name
    title
  end

  def milestones
    return self.project.milestones
  end

  # --- Permissions --- #

  def create_permitted?
    project.project_members.count == 0 || ProjectMember.admin_memberships.include?(project_id)
  end

  def update_permitted?
    ProjectMember.admin_memberships.include?(project_id)||
    acting_user.administrator?
  end

  def destroy_permitted?
    ProjectMember.admin_memberships.include?(project_id)
  end

  def view_permitted?(field)
    project.project_members.count == 0 || ProjectMember.view_memberships.include?(project_id) || project.public_viewable
  end

end
