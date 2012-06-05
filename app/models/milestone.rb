class Milestone < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    date :date
    description :text
    background_color :string
    color         :string, :default => '#000000'
    timestamps
  end

  belongs_to :project
  has_many :items

  default_scope :order => 'date ASC'
  scope :current, lambda { |*args |{:conditions => [ "date > ?", (args.first || Date.today - 14.days) ] }}

  validates_presence_of :date

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
