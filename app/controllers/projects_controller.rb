class ProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  show_action :kanban_board

  def kanban_board
    if request.xhr?
      handle_item_drop
      hobo_ajax_response
      return
    end

    @project = find_instance
    @item = Item.new
    @item.lane = @project.lanes[0]
    @lanes =
      @project.lanes.apply_scopes(:search    => [params[:search], :title],
                                    :status_is => params[:status],
                                    :order_by  => parse_sort_param(:title, :status))

    # @lanelist = @project.lanes.where(["title like ?", "%#{params[:search]}%"]).order(parse_sort_param(:title).join(' '))
  end

  def update
    logger.debug("Enter project_update")
    # @project = find_instance
    hobo_update do
      if valid?
        redirect_to(:controller => 'projects', :action => 'kanban_board')
      end
    end
  end

end
