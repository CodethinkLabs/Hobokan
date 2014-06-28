class LanesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index

  auto_actions_for :project, [:new, :create]
  show_action :show

  show_action :clear do
    @lane = find_instance
    @lane.items.all.each do |i| i.state = "archived"; i.save end
    redirect_to(:back)
  end

end
