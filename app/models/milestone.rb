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
    ProjectMember.memberships.include?(project_id)
  end

  def update_permitted?
    ProjectMember.memberships.include?(project_id)
  end

  def destroy_permitted?
    ProjectMember.memberships.include?(project_id)
  end

  def view_permitted?(field)
    ProjectMember.view_memberships.include?(project_id) || project.public_viewable
  end

end
