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

  set_default_order "date DESC"

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
