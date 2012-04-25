class Item
  def set_updated_by
  end
end

class ReorderLanesAgain < ActiveRecord::Migration
  def self.up
    # ActiveRecord::Base.logger = Logger.new(STDERR)
    Project.all.each do |project|
      project.lanes.each do |lane|
        position = lane.items.length
        items = Item.where(:lane_id => lane.id).order("position ASC").order("created_at DESC")
        items.each do |item|
          item.skip_version do
            # puts "position: #{position} #{item.inspect}"
            item.position = position
            item.save
            position -= 1
          end
        end
      end
    end
  end

  def self.down
    # ActiveRecord::Base.logger = Logger.new(STDERR)
    Project.all.each do |project|
      project.lanes.each do |lane|
        position = lane.items.length
        items = Item.where(:lane_id => lane.id).order("position ASC")
        items.each do |item|
          item.skip_version do
            # puts "position: #{position} #{item.inspect}"
            item.position = position
            item.save
            position -= 1
          end
        end
      end
    end
  end
end
