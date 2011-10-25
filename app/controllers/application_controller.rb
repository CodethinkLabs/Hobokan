class ApplicationController < ActionController::Base
  protect_from_forgery
  include Hobo::Controller::AuthenticationSupport
  before_filter :except => [:login, :forgot_password, :accept_invitation, :do_accept_invitation, :reset_password,
:do_reset_password] do
     login_required unless User.count == 0
  end

  def handle_item_drop
    item = Item.find(params[:item_id])
    old_lane = item.lane
    lane = Lane.find(params[:lane_id])
    item.lane = lane
    item.save
    position = 1
    params[:item_ordering].each do |id|
      item = Item.find(id)
      item.position = position
      item.save
      position += 1
    end

    if old_lane.id != lane.id
      position = 1
      old_lane.items.each do |item|
        item.position = position
        item.save
        position += 1
      end
    end
  end

end
