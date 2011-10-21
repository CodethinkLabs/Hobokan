class ItemsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :lane, :create

  def edit
    if request.xhr?
      @item = Item.find(params[:item_id])
      @old_lane = @item.lane
      @lane = Lane.find(params[:lane_id])
      @item.lane = @lane
      @item.save
      position = 1
      params[:item_ordering].each do |id|
        item = Item.find(id)
        item.position = position
        item.save
        position += 1
      end

      if @old_lane.id != @lane.id
        position = 1
        @old_lane.items.each do |item|
          item.position = position
          item.save
          position += 1
        end
      end

      hobo_ajax_response
      return
    end

    @item = find_instance
  end

end
