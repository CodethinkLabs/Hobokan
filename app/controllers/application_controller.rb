class ApplicationController < ActionController::Base

  protect_from_forgery
  include Hobo::Controller::AuthenticationSupport

  before_filter :except => [:login, :forgot_password, :accept_invitation, :do_accept_invitation, :reset_password,
:do_reset_password] do
     login_required unless User.count == 0
     set_request_environment
  end

  def handle_item_drop
    item = Item.find(params[:item_id])
    old_lane = item.lane
    lane = Lane.find(params[:lane_id])
    item.lane = lane
    item.save
    position = params[:item_ordering].length + 1
    params[:item_ordering].each do |id|
      item = Item.find(id)
      item.position = position
      item.save
      position -= 1
    end

    if old_lane.id != lane.id
      position = old_lane.items.length + 1
      old_lane.items.each do |item|
        item.position = position
        item.save
        position -= 1
      end
    end
  end

private

  # stores parameters for current request
  def set_request_environment
    # current_user is set by restful_authentication
    if current_user.is_a?(User)
      User.current = current_user

      members = ProjectMember.where(:user_id => current_user)
      project_memberships = {}
      members.inject(project_memberships) {|h, m| h[m.project_id] = m}
      memberships = []
      admin_memberships = []

      Project.all.each do |project|
        if project.per_project_permissions
          if project_memberships.has_key?(project.id)
            memberships.push(project.id)
            if project_memberships[project.id].administrator
              admin_memberships.push(project.id)
            end
          end
        else
          memberships.push(project.id)
          admin_memberships.push(project.id)
        end
      end


      ProjectMember.memberships = memberships
      ProjectMember.admin_memberships = admin_memberships
    else
      ProjectMember.memberships = []
      ProjectMember.admin_memberships = []
    end
  end

end
