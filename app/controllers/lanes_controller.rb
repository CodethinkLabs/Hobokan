class LanesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index

  auto_actions_for :project, [:new, :create]
  show_action :kanban_lane

  def kanban_lane
    if request.xhr?
      handle_item_drop
      hobo_ajax_response
      return
    end

    @lane = find_instance
    @project = @lane.project
    @item = Item.new
    @item.lane = @lane
  end

end
