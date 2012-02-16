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
         redirect_to :back
      end
    end
  end

  def show
    @item = find_instance
    @comments = @item.comments
  end
end
