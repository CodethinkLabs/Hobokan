# encoding: utf-8

class Lane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title         :string
    position      :integer
    background_color :string
    color         :string
    timestamps
  end

  children :items
  acts_as_list :scope => :project
  belongs_to :project
  has_many :items, :order => "position"

  set_default_order "position ASC"
  validates_length_of :title, :within => 4..50, :too_long => "pick a shorter name", :too_short => "pick a longer name"

  def name
    title
  end

  def state
    "L#{id}\u000B#{title}\u000B#{background_color}\u000B#{color}"
  end

  def states
    state
  end

  def stories
    items.active.map {|item| "L#{self.id}\u000BS#{item.id}\u000B#{item.title}" }.join("\n")
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
