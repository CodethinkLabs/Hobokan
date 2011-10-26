class Item < ActiveRecord::Base

  hobo_model # Don't put anything above this
  versioned

  fields do
    start_date         :date
    end_date           :date
    title              :string
    text               :text
    estimation         :float
    position           :integer
    wip_total          :integer
    current_lane_entry :datetime
    timestamps
  end

  # validates_date :start_date, :on_or_after => Date.today
  # validates_date :end_date, :on_or_after => Date.today

  children :checklist_items
  children :users

  has_many :statistics, :dependent => :destroy
  has_many :history_entries
  has_many :checklist_items, :accessible => true

  has_many :users, :through => :item_users, :accessible => true
  has_many :item_users, :dependent => :destroy

  belongs_to :lane
  belongs_to :last_editor, :class_name => 'User'

  # acts_as_list :scope => :lane
  set_default_order "position ASC"

  WIP_TOTAL_WARN = 3600*24*10 # 10 days
  WIP_TOTAL_URGENT = 3600*24*20 # 20 days

  lifecycle do
    state :normal, :default => :true
    state :warn
    state :urgent
  end

  def wip_current
    return 0 if !self.current_lane_entry
    return (Time.now - self.current_lane_entry)
  end

  def to_lane(lane)
    Lane.find(lane)
  end

  before_create :update_position, :set_updated_by
  before_save :update_time_counters, :set_updated_by
  after_save :update_statistics

  def set_updated_by
    self.updated_by = acting_user
  end

  def update_position
    self.position = lane.items.count + 1
  end

  def update_statistics
    # users.each {|u| update_statistics_for_user(u) }
  end

  def update_statistics_for_user(user)
    unless changed? and !changes["lane_id"].nil?
      Statistic.create(:lane => self.lane, :user => user, :item => self, :entry_time => Time.now) if self.new_record? && self.lane
      if !self.new_record? && !changes["user_id"].nil?
        stat = Statistic.find(:first, :order => 'id DESC', :conditions => {:lane_id => self.lane, :item_id => self})
        stat.update_attribute(:user_id, changes["user_id"][1]) if stat
      end
      return
    end
    old_lane_id,new_lane_id = changes["lane_id"]

    old_lane = to_lane(old_lane_id) if old_lane_id
    new_lane =  to_lane(new_lane_id) if new_lane_id
    if old_lane
      stat = Statistic.find(:first, :order => 'id DESC', :conditions => {:lane_id => old_lane, :item_id => self})
      stat.update_attribute(:leave_time, Time.now) if stat
    end
    Statistic.create(:lane => new_lane, :user => self.user, :item => self, :entry_time => Time.now) if new_lane
  end

  # wip counters - needed to determine the current and the overall WIP
  # wip_current - for the current lane
  # wip_total - for all lanes
  def update_time_counters
    unless changed? and !changes["lane_id"].nil?
      self.current_lane_entry = Time.now if self.new_record? && self.lane && self.lane.counts_wip
      return
    end
    old_lane_id,new_lane_id = changes["lane_id"]

    old_lane = to_lane(old_lane_id) if old_lane_id
    new_lane =  to_lane(new_lane_id) if new_lane_id

    # add the time spent in the old_lane to the wip_total
    if old_lane and  current_lane_entry #and old_lane.counts_wip # not_needed?
      self.wip_total ||= 0
      self.wip_total += (Time.now - self.current_lane_entry)
      self.current_lane_entry=nil
    end
    # start new counter for the new lane, if needed
    if new_lane and new_lane.counts_wip
      self.current_lane_entry=Time.now
    end
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.signed_up?
   end

  def update_permitted?
    acting_user.signed_up?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
