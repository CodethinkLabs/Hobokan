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
