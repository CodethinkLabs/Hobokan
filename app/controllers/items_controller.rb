class ItemsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :project, [:new, :create]
  show_action :ajax_item

  def create_for_project
    hobo_create do
      if valid?
        @item.state = "created"
        @item.save
        if request.xhr?
          render :partial => "ajax_box"
          return
        end

        redirect_to :back
      end
    end
  end

  def do_archive
    item = find_instance
    item.state = "archived"
    item.lane = item.project.lanes.last
    item.save
    redirect_to :back
  end

  def ajax_item
    if request.xhr?
      @item = find_instance
      render :partial => "ajax_item"
      return
    end
  end

  def edit
    @item = find_instance
  end

  def update
    @item = find_instance
    if @item.lane.id != params[:item][:lane_id]
      @item.lane = Lane.find(params[:item][:lane_id])
      @item.enqueue_item
      Lane.move_item(current_user, @item)
    end

    hobo_update do
      if valid?
        if request.xhr?
          render :partial => "ajax_box"
          return
        end

        item = find_instance
        redirect_to :back
      end
    end
  end

  def show
    @item = find_instance
    @comments = @item.comments
  end
end
