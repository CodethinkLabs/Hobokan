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
    acting_user.signed_up?
  end

  def update_permitted?
    acting_user.signed_up?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.signed_up? || item.project.public_viewable
  end

end
