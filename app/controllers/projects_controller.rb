class ProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  show_action :kanban, :done, :stats

  def index
    hobo_index Project.active.apply_scopes(:search   => [params[:search], :name, :state],
                                    :order_by => parse_sort_param(:name),
                                    :user_is => params[:user])
  end

  def done
    @project = find_instance
    @done = @project.items.done.apply_scopes(:milestone_is => params[:milestone], :order_by => 'updated_at DESC') 
  end

  def stats
    @project = find_instance
    @done = @project.items.done.apply_scopes(:milestone_is => params[:milestone])
    @todo = @project.items.apply_scopes(:milestone_is => params[:milestone])

    project_days = (Date.today - @project.items.first.created_at.to_date).to_i

    @started =  Array.new(52,0)
    @finished = Array.new(52,0)

    @todo.each { |todo| i = todo.created_at.to_date.cweek - 1 ; @started[i] = @started[i] + 1 }
    @done.each { |done| i = done.updated_at.to_date.cweek - 1 ; @finished[i] = @finished[i] + 1  }
  end

  def kanban
    @project = find_instance
    @items = @project.items.active.apply_scopes(:milestone_is => params[:milestone])

    if params[:lane]
      @lanes = @project.lanes.apply_scopes(:title_is => params[:lane])
    else
      @lanes = @project.lanes.visible
    end

    if request.xhr?
      handle_item_drop
      hobo_ajax_response
      return
    end
  end

  def create
    hobo_create do
      if valid?
        lane = Lane.new
        lane.project = this
        lane.title = "Wishlist"
        lane.position = 1
        lane.background_color = "#FFFFDD"
        lane.save

        lane = Lane.new
        lane.project = this
        lane.title = "Buglist"
        lane.position = 2
        lane.background_color = "#FFAAAA"
        lane.save

        lane = Lane.new
        lane.project = this
        lane.title = "Backlog"
        lane.position = 3
        lane.background_color = "#B5DBFF"
        lane.save

        lane = Lane.new
        lane.project = this
        lane.title = "Doing"
        lane.position = 4
        lane.background_color = "#99FF99"
        lane.save

        lane = Lane.new
        lane.project = this
        lane.title = "Done"
        lane.position = 5
        lane.background_color = "#999999"
        lane.save

        p = ProjectMember.new
        p.user = current_user
        p.project = this
        p.save

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
