class Comment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    detail      :text
    timestamps
  end

  belongs_to :user, :class_name => "User", :creator => true
  belongs_to :item

  set_default_order "created_at DESC"
  set_search_columns :detail

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
