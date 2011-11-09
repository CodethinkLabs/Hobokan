class Item
  def set_updated_by
  end
end

class ReorderLanes < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.logger = Logger.new(STDERR)
    Project.all.each do |project|
      project.lanes.each do |lane|
        length = lane.items.length
        lane.items.each do |item|
          item.skip_version do
            puts "length: #{length} #{item.inspect}"
            item.position = (length - item.position) + 1
            item.save
          end
        end
      end
    end
  end

  def self.down
  end
end
