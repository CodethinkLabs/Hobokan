class ApplicationController < ActionController::Base

  protect_from_forgery
  include Hobo::Controller::AuthenticationSupport

  before_filter :except => [:login, :forgot_password, :accept_invitation, :do_accept_invitation, :reset_password,
:do_reset_password] do
     # login_required unless User.count == 0
     set_request_environment
  end

  before_filter :prepare_for_mobile

  def handle_item_drop
    id = params[:item_id]
    target = params[:item_position].to_i
    lane = Lane.find(params[:lane_id])

    dropped = Item.find(id)
    dropped.lane = lane
    dropped.position = target
    dropped.save

    if lane.title != "Done"
      count = 0
      lane.items.each do |item|
        if item != dropped
          if count == target
            count = count + 1
          end
          item.position = count
          item.save
          count = count + 1
        end
      end
    end
  end

private

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end

  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
  end

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
