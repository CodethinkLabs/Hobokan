class ApplicationController < ActionController::Base

  protect_from_forgery
  include Hobo::Controller::AuthenticationSupport

  before_filter :except => [:login, :forgot_password, :accept_invitation, :do_accept_invitation, :reset_password,
:do_reset_password] do
     login_required unless User.count == 0
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


end
