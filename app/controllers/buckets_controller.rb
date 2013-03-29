class BucketsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :project, [:new, :create]

  def update
    hobo_update do
      if valid?
        redirect_to(:controller => 'projects', :id => this.project ,:action => 'kanban')
      end
    end
  end

  def create_for_project
    hobo_create do
      if valid?
        redirect_to(:back)
      end
    end
  end

end
