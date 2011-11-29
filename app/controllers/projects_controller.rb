class ProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  show_action :kanban

  def kanban
    @project = find_instance
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
        redirect_to(:controller => 'projects', :action => 'kanban')
      end
    end
  end

end
