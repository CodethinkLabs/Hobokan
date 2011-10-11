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

  before_save :calc_duration

  def calc_duration
    if entry_time && leave_time
      number_of_days = (self.leave_time - self.entry_time) / (3600 * 24)
      number_of_days = (number_of_days - 0.5).round
      week_day_of_leave = self.leave_time.wday
      self.duration = self.leave_time - self.entry_time
      self.duration -= ((number_of_days / 7) * 2 * 3600 * 24)
      self.duration -= (2 * 3600 * 24 ) if (number_of_days % 7) - 2 >= week_day_of_leave
    end
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
