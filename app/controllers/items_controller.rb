class ItemsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :lane, [:new, :create]
  show_action :ajax_item

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
        @item.state = "created"
        @item.save
        lane = @item.lane.project.lanes[0]
        project = @item.lane.project
        redirect_to(:controller => 'projects', :action => 'kanban', :id => @item.lane.project.id)
      end
    end
  end

  def do_archive
    item = find_instance
    item.state = "archived"
    item.save
    redirect_to(:controller => 'projects', :action => 'kanban', :id => item.lane.project.id)
  end

  def ajax_item
    if request.xhr?
      @item = find_instance
      logger.debug("item: #{@item}")
      render :partial => "ajax_item", :locals => {:my_item => @item}
      return
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
         redirect_to(:controller => 'projects', :action => 'kanban', :id => @item.lane.project.id)
      end
    end
  end

end
