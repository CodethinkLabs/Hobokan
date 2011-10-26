class Project < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    timestamps
  end

  children :lanes

  has_many :lanes, :order => :position, :accessible => true
  has_one :backlog, :class_name => 'Lane', :conditions => {:title => 'Backlog'}
  has_one :livelog, :class_name => 'Lane', :conditions => {:title => 'Live'}
  has_one :parking, :class_name => 'Lane', :conditions => {:title => 'Parking'}

  after_create :setup_lanes

  def setup_lanes
    lane = Lane.new
    lane.title = 'Wishlist'
    lane.position = 1
    lane.project = self
    lane.background_color = '#FFFF00'
    lane.color = '#000000'
    lane.save

    lane = Lane.new
    lane.title = 'Buglist'
    lane.position = 2
    lane.project = self
    lane.background_color = '#FF0000'
    lane.color = '#000000'
    lane.save

    lane = Lane.new
    lane.title = 'Backlog'
    lane.position = 3
    lane.project = self
    lane.background_color = '#B5DBFF'
    lane.color = '#000000'
    lane.save

    lane = Lane.new
    lane.title = 'Doing'
    lane.position = 4
    lane.project = self
    lane.background_color = '#A5C700'
    lane.color = '#000000'
    lane.save

    lane = Lane.new
    lane.title = 'Done'
    lane.position = 5
    lane.project = self
    lane.background_color = '#999999'
    lane.color = '#000000'
    lane.save

  end

  def states
    lanes.map { |lane| "L#{lane.id},#{lane.title},#{lane.background_color},#{lane.color}"}.join("\n")
  end

  def stories
    result = []
    lanes.each do |lane|
      result << lane.items.map {|item| "L#{lane.id},S#{item.id},#{item.title}" }
    end

    return result.join("\n")
  end

  class Change
    attr_accessor :user, :comment, :date

    def [](a)
      return a.to_s
    end
  end

  def changes
    versions = Version.find(:all)
    result = []
    versions.each do |v|
      change = Change.new
      change.user = v.user_id ? v.user_id : 'anon'
      change.date = v.created_at
      if v.modifications['text']
        change.comment = v.modifications['text'][1]
      elsif v.modifications['position']
        change.comment = v.modifications['position'][1].to_s
      elsif v.modifications['lane_id']
         change.comment = v.modifications['lane_id'][1].to_s
      else
        change.comment = ""
      end

      result << change
    end

    return result
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
