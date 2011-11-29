# encoding: utf-8

class Project < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    per_project_permissions :boolean, :default => false
    timestamps
  end

  children :lanes
  children :project_members

  has_many :lanes, :order => :position, :dependent => :destroy, :accessible => true
  has_many :items, :dependent => :destroy
  has_many :project_members, :accessible => true
  has_many :users, :through => :project_members

  validates_length_of :name, :within => 4..50, :too_long => "pick a shorter name", :too_short => "pick a longer name"

  validate :lane_present

  def lane_present
    logger.debug("Project#lane_present lanes: #{lanes.inspect}")
    errors.add :lanes, 'you must enter at least one lane' if lanes.nil? || lanes.length == 0
  end

  def states
    lanes.map { |lane| lane.state}.join("\n")
  end

  def stories
    result = []
    lanes.each do |lane|
      result << lane.stories
    end

    return result.join("\n")
  end

  def versions
    return VestalVersions::Version.where(:versioned_id => items).order("created_at DESC").limit(50)
  end


  # --- Permissions --- #

  def create_permitted?
    acting_user.signed_up?
  end

  def update_permitted?
    acting_user.signed_up?
  end

  def destroy_permitted?
    acting_user.signed_up?
  end

  def view_permitted?(field)
    true
  end

end
