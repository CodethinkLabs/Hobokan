class ProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def show
    @project = find_instance
    # @lanelist = @project.lanes.where(["title like ?", "%#{params[:search]}%"]).order(parse_sort_param(:title).join(' '))
  end

end
