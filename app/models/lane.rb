class Lane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title         :string
    max_items     :integer
    position      :integer
    super_lane_id :integer
    type          :string
    counts_wip    :boolean
    warn_limit    :integer
    urgent_limit  :integer
    dashboard     :boolean
    timestamps
  end

  # children :sub_lanes, :items, :statistics
  acts_as_list

  belongs_to :project
  belongs_to :super_lane, :class_name => 'Lane', :foreign_key => 'super_lane_id'

  has_many :sub_lanes, :class_name => 'Lane', :foreign_key => 'super_lane_id', :order => :position

  has_many :items, :order => "position"

  has_many :statistics

  scope :on_dashboard, :conditions => {:dashboard => true}
  scope :top_level, :conditions => {:super_lane_id => nil}, :order => :position
  scope :standard, :conditions => {:type => 'StandardLane', :super_lane_id => nil}, :order => :position
  scope :restricted, :conditions => {:type => 'RestrictedLane', :super_lane_id => nil}, :order => :position

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
