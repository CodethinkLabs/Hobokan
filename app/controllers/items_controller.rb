class ItemsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  auto_actions_for :lane, [:new, :create]

  def new_for_lane
    if request.xhr?
      handle_item_drop
      hobo_ajax_response
      return
    end

    if !@item
      @item = Item.new
      @lane = Lane.user_find(current_user, params[:lane_id])
      @item.lane = @lane
    end
  end

  def create
    hobo_create do
      if valid?
        lane = @item.lane.project.lanes[0]
        redirect_to (@item.lane.project)
      end
    end
  end

  def edit
    if request.xhr?
      handle_item_drop
      hobo_ajax_response
      return
    end

    @item = find_instance
  end


  def update
    hobo_update do
      if valid?
        item = find_instance
        redirect_to (item.lane.project)
      end
    end
  end

end
