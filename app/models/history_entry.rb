class HistoryEntry < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    action       :string
    trigger_type :string
    trigger_id   :integer
    delta        :text
    timestamps
  end

  belongs_to :item
  belongs_to :trigger, :polymorphic => true

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
