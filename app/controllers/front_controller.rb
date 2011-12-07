class FrontController < ApplicationController

  hobo_controller

  def index
    if !current_user.is_a?(User)
      redirect_to users_path
    end
  end

  def summary
    if !current_user.administrator?
      redirect_to user_login_path
    end
  end

  def search
    if params[:query]
      site_search(params[:query])
    end
  end

end
