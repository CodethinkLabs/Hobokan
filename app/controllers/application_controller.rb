class ApplicationController < ActionController::Base

  protect_from_forgery
  include Hobo::Controller::AuthenticationSupport

  before_filter :except => [:login, :forgot_password, :accept_invitation, :do_accept_invitation, :reset_password,
:do_reset_password] do
     login_required unless User.count == 0
     set_request_environment
  end

  def handle_item_drop
    position = params[:item_ordering].length
    lane = Lane.find(params[:lane_id])
    params[:item_ordering].each do |id|
      item = Item.find(id)
      item.lane = lane
      item.position = position
      item.save
      position -= 1
    end
  end

private

  # Stores parameters for current request
  def set_request_environment
    # Current_user is set by restful_authentication
    if current_user.is_a?(User)
      User.current = current_user

      # Build two arrays 'memberships' and 'admin_memberships' which contain
      # a list of the project ids for which the user is a member of the project,
      # and is an adminstrative member respectively.
      #
      # These two cached arrays are then used by the Hobo permissions methods in the
      # models via the ProjectMember#memberships and admin_memberships methods.
      memberships = []
      admin_memberships = []
      view_memberships = []

      members = ProjectMember.where(:user_id => current_user)
      members.each do |member|
        memberships.push(member.project_id)
        admin_memberships.push(member.project_id) unless !member.administrator
        view_memberships.push(member.project_id)
      end

      logger.debug("ApplicationController#set_request_environment #{members.inspect}")

      Project.all.each do |project|
        # Clients can only view projects of which they are a member, but anyone
        # else can view all the projects
        if current_user.role == :sales || current_user.role == :developer ||current_user.role == :manager
          view_memberships.push(project.id)
        end
      end

      ProjectMember.memberships = memberships
      ProjectMember.admin_memberships = admin_memberships
      ProjectMember.view_memberships = view_memberships
    else
      ProjectMember.memberships = []
      ProjectMember.admin_memberships = []
      ProjectMember.view_memberships = []
    end
  end

end
