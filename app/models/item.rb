class Item < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    start_date         :date
    end_date           :date
    title              :string
    text               :text
    owner_id           :integer
    estimation         :float
    position           :integer
    wip_total          :integer
    current_lane_entry :datetime
    last_editor_id     :integer
    timestamps
  end

  # children :statistics, :history_entries

  has_many :statistics, :dependent => :destroy

  has_many :history_entries
  belongs_to :lane
  belongs_to :owner, :class_name => 'User'
  belongs_to :last_editor, :class_name => 'User'

  acts_as_list :scope => :lane

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
