class Project < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    timestamps
  end

  children :lanes
  # children :backlogs, :livelogs, :parkings

  has_many :lanes, :order => :position
  has_one :backlog, :class_name => 'Lane', :conditions => {:title => 'Backlog'}
  has_one :livelog, :class_name => 'Lane', :conditions => {:title => 'Live'}
  has_one :parking, :class_name => 'Lane', :conditions => {:title => 'Parking'}

  after_create :setup_lanes

  def setup_lanes
    lane = Lane.new
    lane.title = 'ProductMgt Ready'
    lane.position = 1
    lane.project = self
    lane.save

    lane = Lane.new
    lane.title = 'ProductMgt'
    lane.position = 2
    lane.project = self
    lane.save

    lane = Lane.new
    lane.title = 'Design Ready'
    lane.position = 3
    lane.project = self
    lane.save

    lane = Lane.new
    lane.title = 'Design'
    lane.position = 4
    lane.project = self
    lane.save

    lane = Lane.new
    lane.title = 'Development Ready'
    lane.position = 5
    lane.project = self
    lane.save

    lane = Lane.new
    lane.title = 'Development'
    lane.position = 6
    lane.project = self
    lane.save

    lane = Lane.new
    lane.title = 'Test Ready'
    lane.position = 7
    lane.project = self
    lane.save

    lane = Lane.new
    lane.title = 'Test'
    lane.position = 8
    lane.project = self
    lane.save

    lane = Lane.new
    lane.title = 'Release Ready'
    lane.position = 9
    lane.project = self
    lane.save

    lane = Lane.new
    lane.title = 'Release'
    lane.position = 10
    lane.project = self
    lane.save

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
