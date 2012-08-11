class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all, :except => [ :new, :create ]
  index_action :workload
  show_action :done

  # Normally, users should be created via the user lifecycle, except
  #  for the initial user created via the form on the front screen on
  #  first run.  This method creates the initial user.
  def create
    hobo_create do
      if valid?
        self.current_user = this
        flash[:notice] = t("hobo.messages.you_are_site_admin", :default=>"You are now the site administrator")
        redirect_to home_page
      end
    end
  end

  def do_accept_invitation
    do_transition_action :accept_invitation do
      if this.valid?
        self.current_user = this
        flash[:notice] = t("hobo.messages.you_signed_up", :default=>"You have signed up")
      end
    end
  end

  def done
    @user = find_instance
    if params[:user]
      @user = User.find_by_name(params[:user])
    end
    @done = Array.new
    pm = @user.project_members
    pm.all.each do |apm|
      @done = @done + apm.items.done.apply_scopes(:milestone_is => params[:milestone],
              :order_by => 'end_date DESC')
    end
    @done.sort! { |a,b| b.end_date <=> a.end_date }
    @done = @done.paginate(:page => params[:page])
  end

end
