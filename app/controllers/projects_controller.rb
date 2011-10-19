class ProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def show
    @project = find_instance
    @lanes =
      @project.lanes.apply_scopes(:search    => [params[:search], :title],
                                    :status_is => params[:status],
                                    :order_by  => parse_sort_param(:title, :status))
  end

  show_action :kanban_board

  def kanban_board
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

    @project = find_instance
    @lanes =
      @project.lanes.apply_scopes(:search    => [params[:search], :title],
                                    :status_is => params[:status],
                                    :order_by  => parse_sort_param(:title, :status))

    # @lanelist = @project.lanes.where(["title like ?", "%#{params[:search]}%"]).order(parse_sort_param(:title).join(' '))
  end
end
