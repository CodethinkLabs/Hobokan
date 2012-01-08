class MilestonesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index

  def update
    hobo_update do
      if valid?
        redirect_to(:controller => 'projects', :id => this.project ,:action => 'kanban')
      end
    end
  end

end
