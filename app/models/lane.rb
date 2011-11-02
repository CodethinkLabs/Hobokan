# encoding: utf-8

class Lane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title         :string
    max_items     :integer, :default => 25
    position      :integer
    type          :string
    counts_wip    :boolean
    warn_limit    :integer, :default => 10
    urgent_limit  :integer, :default => 10
    dashboard     :boolean, :default => false
    background_color :string
    color         :string
    timestamps
  end

  children :items
  acts_as_list :scope => :project
  belongs_to :project
  has_many :items, :order => "position"
  has_many :statistics
  scope :on_dashboard, :conditions => {:dashboard => true}

  set_default_order "position ASC"

  def name
    title
    # title.gsub(/\s/, "_").downcase
  end

  def can_take_more_items?
    max_items == 0 ||  items.count < max_items
  end

  def self.test_lane_id
    lane = find_by_title "Testing"
    lane ? lane.id : -1
  end

  def self.progress_lane_id
    lane = find_by_title "In progress"
    lane ? lane.id : -1
  end

  def self.ids_not_wip_relevant
    find(:all, :conditions => ["title IN (?)", ["Backlog", "Live", "Selected", "Live - Junkyard"]]).map_by_id
  end

  # --- Permissions --- #

  def create_permitted?
    project.project_admin?(acting_user)
  end

  def update_permitted?
    project.project_admin?(acting_user)
  end

  def destroy_permitted?
    project.project_admin?(acting_user)
  end

  def view_permitted?(field)
    true
  end

end
