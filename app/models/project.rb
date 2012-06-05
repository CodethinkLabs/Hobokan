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
  has_many :items, :dependent => :destroy, :accessible => true
  has_many :project_members
  has_many :users, :through => :project_members, :accessible => true
  has_many :milestones, :accessible => true

  validates_length_of :name, :within => 4..50, :too_long => "pick a shorter name", :too_short => "pick a longer name"

  def versions
    v = Version.arel_table
    return Version.where(:versioned_id => items).where(v[:modifications].matches("%lane_id%")).order("created_at DESC").limit(50)
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
