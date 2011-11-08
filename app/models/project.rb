# encoding: utf-8

class Project < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    per_project_permissions :boolean, :default => false
    timestamps
  end

  children :lanes
  children :project_members

  has_many :lanes, :order => :position, :accessible => true
  # has_many :items
  has_many :project_members, :accessible => true

  validates_length_of :name, :within => 4..50, :too_long => "pick a shorter name", :too_short => "pick a longer name"

  def states
    lanes.map { |lane| lane.state}.join("\n")
  end

  def stories
    result = []
    lanes.each do |lane|
      result << lane.stories
    end

    return result.join("\n")
  end

  class Change
    attr_accessor :user, :comment, :date
  end

  def changes
    member_ids = project_members.map {|m| m.id }
    versions = Version.where(:user_id => member_ids).where(:user_type => 'ProjectMember').order("created_at DESC")
    result = []
    versions.each do |v|
      change = Change.new
      change.user = v.user_id ? project_members.find(v.user_id).user.name : 'anon'
      change.date = v.created_at.strftime("%d/%m/%Y")
      change.comment = ""
      title = Item.find(v.versioned_id).title

      if v.modifications['title']
        change.comment += "Renamed S#{v.versioned_id} '#{v.modifications['title'][0]}' as '#{v.modifications['title'][1]}'"
      end

      if v.modifications['text']
        change.comment += v.modifications['text'][1].to_s
      end

#      if v.modifications['position']
#        change.comment += "'#{title}' position changed from #{v.modifications['position'][0]} to #{v.modifications['position'][1]} "
#      end

      if v.modifications['lane_id']
         change.comment += "Moved '#{title}' from #{Lane.find(v.modifications['lane_id'][0]).title} to #{Lane.find(v.modifications['lane_id'][1]).title} "
      end

      if change.comment != ""
        result << change
      end
    end

    return result
  end

  def project_member?(user)
    (!per_project_permissions && user.signed_up?) ||
    project_members.exists?(:user_id => user)
  end

  def project_admin?(user)
    (!per_project_permissions && user.signed_up?) ||
    (project_members.exists?(:user_id => user) && project_members.first(:user_id => user).administrator?)
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.signed_up?
  end

  def update_permitted?
    acting_user.signed_up?
  end

  def destroy_permitted?
    acting_user.signed_up?
  end

  def view_permitted?(field)
    true
  end

end
