class PruneLanes < ActiveRecord::Migration
  def self.up
    # ActiveRecord::Base.logger = Logger.new(STDERR)
    project_ids = Project.all.map {|project| project.id}
    Lane.all.each do |lane|
      if project_ids.include?(lane.project_id)
        puts "Valid lane: #{lane.inspect}"
      else
        # puts "Invalid lane: #{lane.inspect}"
        lane.destroy
      end
    end
  end

  def self.down
  end
end
