class Milestone < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    date :date
    background_color :string
    color         :string, :default => '#000000'
    timestamps
  end

  belongs_to :project
  has_many :items

  default_scope :order => 'date ASC'

  # --- Permissions --- #

  def create_permitted?
    logger.debug("Milestone#create_permitted? #{ProjectMember.memberships.inspect} project_id: #{project_id}")
    ProjectMember.memberships.include?(project_id)
  end

  def update_permitted?
    logger.debug("Milestone#update_permitted? #{ProjectMember.memberships.inspect} project_id: #{project_id}")
    ProjectMember.memberships.include?(project_id)
  end

  def destroy_permitted?
    ProjectMember.memberships.include?(project_id)
  end

  def view_permitted?(field)
    logger.debug("Milestone#view_permitted? #{ProjectMember.view_memberships.inspect} project_id: #{project_id}")
    ProjectMember.view_memberships.include?(project_id)
  end

end
