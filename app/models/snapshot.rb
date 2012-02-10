class Snapshot < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    count :integer
    date :date
  end
  
  belongs_to :lane
  belongs_to :milestone

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
