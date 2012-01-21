class ProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  show_action :kanban

  def index
    hobo_index Project.active.apply_scopes(:search   => [params[:search], :name, :state],
                                    :order_by => parse_sort_param(:name),
                                    :user_is => params[:user])
  end

  def kanban
    @project = find_instance
    @items = @project.items.active.apply_scopes(:milestone_is => params[:milestone])

    if request.xhr?
      handle_item_drop
      hobo_ajax_response
      return
    end
  end

  def create
    hobo_create do
      if valid?
        redirect_to(:controller => 'projects', :action => 'kanban', :id => @project.id)
      end
    end
  end

  def update
    hobo_update do
      if valid?
        redirect_to(:controller => 'projects', :action => 'show')
      end
    end
  end

end
