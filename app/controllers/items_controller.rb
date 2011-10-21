class ItemsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :lane, [:new, :create]

  def new_for_lane
    if request.xhr?
      handle_item_drop
      hobo_ajax_response
      return
    end

    @item = Item.new
    @lane = Lane.user_find(current_user, params[:lane_id])
    @item.lane = @lane
  end

  def edit
    if request.xhr?
      handle_item_drop
      hobo_ajax_response
      return
    end

    @item = find_instance
    # hobo_update
  end

  def handle_item_drop
    item = Item.find(params[:item_id])
    old_lane = item.lane
    lane = Lane.find(params[:lane_id])
    item.lane = lane
    item.save
    position = 1
    params[:item_ordering].each do |id|
      item = Item.find(id)
      item.position = position
      item.save
      position += 1
    end

    if old_lane.id != lane.id
      position = 1
      old_lane.items.each do |item|
        item.position = position
        item.save
        position += 1
      end
    end
  end
end
