# encoding: utf-8

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
    timestamps
  end

  # validates_date :start_date, :on_or_after => Date.today
  # validates_date :end_date, :on_or_after => Date.today

  children :checklist_items

  has_many :checklist_items, :dependent => :destroy, :accessible => true

  has_many :project_members, :through => :item_project_members, :accessible => true
  has_many :item_project_members, :dependent => :destroy

  belongs_to :lane
  belongs_to :project

  # acts_as_list :scope => :lane
  set_default_order "position DESC"

  lifecycle do
    state :normal, :default => :true
    state :warn
    state :urgent
    state :archived

    transition :archive, { :normal => :archived }, :available_to => "User"
  end

  scope :active, :conditions => "state != 'archived'"

  before_create :enqueue_item, :set_updated_by, :set_project
  before_save :set_updated_by

  def set_updated_by
    members = project.project_members
    member = members.find(:first, :conditions => "user_id = #{User.current.id}")
    self.updated_by = (member ? member : User.current)
  end

  def set_project
    self.project = lane.project
  end

  def enqueue_item
    self.position = lane.items.count + 1
  end

  # --- Permissions --- #

  def create_permitted?
    lane.project.project_member?(acting_user)
   end

  def update_permitted?
    project.project_member?(acting_user)
  end

  def destroy_permitted?
    project.project_admin?(acting_user)
  end

  def view_permitted?(field)
    true
  end

end
