class ProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  show_action :kanban, :done, :stats, :change_log

  def index
    hobo_index Project.active.apply_scopes(:search   => [params[:search], :name, :state],
                                    :order_by => parse_sort_param(:name),
                                    :user_is => params[:user])
  end

  def done
    @project = find_instance
    @done = @project.items.done.apply_scopes(:milestone_is => params[:milestone],
            :order_by => 'end_date DESC')

    if params[:user]
      @user = User.find_by_name(params[:user])
      @done = @done.find_all { |item| (item.project_members.find_all {|pm| pm.user == @user } != []) }
    end
    @count = @done.count
    @done = @done.paginate(:page => params[:page])

    @recent = Array.new
    for i in 0..30
      @recent[30 - i] = @project.items.done.apply_scopes(:milestone_is => params[:milestone], :end_date_is => Date.today - i.days,
            :order_by => 'end_date DESC').paginate(:page => params[:page]).count
    end
  end

  def stats
    @project = find_instance
    @done = @project.items.done.apply_scopes(:milestone_is => params[:milestone])
    @todo = @project.items.apply_scopes(:milestone_is => params[:milestone])

    project_days = (Date.today - @project.items.first.created_at.to_date).to_i

    @started =  Array.new(52,0)
    @finished = Array.new(52,0)

    @todo.each { |todo| i = todo.created_at.to_date.cweek - 1 ; @started[i] = @started[i] + 1 }
    @done.each { |done| i = done.end_date.cweek - 1 ; @finished[i] = @finished[i] + 1  }
  end

  def change_log
    @project = find_instance
    render :partial => "ajax_change_log", :locals => {:this=> @project}
  end

  def kanban
    if request.xhr?
      dropped = Item.find(params[:item_id])
      dropped.lane = Lane.find(params[:lane_id])
      dropped.position = params[:item_position].to_i
      Lane.move_item(current_user, dropped)

      # We don't need to render anything, just stop the
      # spinner once the AJAX response have been received
      # by the client
      render :nothing => true
      return
    end

    @project = find_instance
    @milestones = @project.milestones.current.all << "No Milestones"
    @buckets = @project.buckets.not_done.all
    @items = @project.items.apply_scopes(:bucket_is => params[:bucket], :milestone_is => params[:milestone])

    if params[:lane]
      @lanes = @project.lanes.apply_scopes(:title_is => params[:lane])
    else
      @lanes = @project.lanes.visible
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
        lane.closed = true
        lane.todo = false
        lane.save

        lane = Lane.new
        lane.project = this
        lane.title = "Not going to fix"
        lane.position = 0
        lane.background_color = "#FFFFFF"
        lane.closed = true
        lane.todo = false
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
