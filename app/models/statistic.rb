class Statistic < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    entry_time :datetime
    leave_time :datetime
    duration   :integer
    timestamps
  end

  belongs_to :lane
  belongs_to :item
  belongs_to :user

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
