class Item
  def set_updated_by
  end
end

class FixItemPositions < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.logger = Logger.new(STDERR)
    Project.all.each do |project|
      project.lanes.each do |lane|
        items = Item.where(:lane_id => lane.id).where("state <> 'archived'").order("position DESC")
        position = items.length
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
  end
end
