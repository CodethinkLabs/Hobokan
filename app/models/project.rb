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

  has_many :lanes, :order => :position, :dependent => :destroy, :accessible => true
  has_many :items, :dependent => :destroy
  has_many :project_members, :accessible => true

  validates_length_of :name, :within => 4..50, :too_long => "pick a shorter name", :too_short => "pick a longer name"

  validate :lane_present

  def lane_present
    logger.debug("Project#lane_present lanes: #{lanes.inspect}")
    errors.add :lanes, 'you must enter at least one lane' if lanes.nil? || lanes.length == 0
  end

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
    members = project_members
    member_ids = members.map {|m| m.id }

    user_names = {}
    members.each do |member|
      # logger.debug("member: #{member.inspect} #{member.user.inspect}")
      # logger.debug(user_names)
      user_names[member.id] = member.user.name
    end

    versions = VestalVersions::Version.
                  where(:user_id => member_ids).
                  where(:user_type => 'ProjectMember').
                  where("created_at > ?", Date.today - 7).
                  order("created_at DESC")
    result = []
    versions.each do |v|
      change = Change.new

      if user_names.has_key?(v.user_id)
        change.user = user_names[v.user_id]
      else
        change.user = 'anon'
      end

      change.date = v.created_at.strftime("%d/%m/%Y")
      change.comment = ""

      if v.modifications['title']
        change.comment += "Renamed S#{v.versioned_id} '#{v.modifications['title'][0]}' as '#{v.modifications['title'][1]}'"
      end

      if v.modifications['text']
        change.comment += v.modifications['text'][1].to_s
      end

#      if v.modifications['position']
#        title = Item.find(v.versioned_id).title
#        change.comment += "'#{title}' position changed from #{v.modifications['position'][0]} to #{v.modifications['position'][1]} "
#      end

      if v.modifications['lane_id']
        title = Item.find(v.versioned_id).title
        change.comment += "Moved '#{title}' from #{Lane.find(v.modifications['lane_id'][0]).title} to #{Lane.find(v.modifications['lane_id'][1]).title} "
      end

      if change.comment != ""
        result << change
      end
    end

    return result
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
