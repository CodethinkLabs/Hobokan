class ActiveRecord::Base
  def generate_update_query(project_id)
    "UPDATE items SET project_id = #{project_id} where id = #{self.id}"
  end

  def raw_update(project_id)
    self.class.connection.execute(self.generate_update_query(project_id))
  end
end

class PopulateItemProject < ActiveRecord::Migration
  def self.up
    # ActiveRecord::Base.logger = Logger.new(STDERR)

    Item.all.each do |item|
      # For some reason the following doesn't work:
      #     item.project = item.lane.project
      #     item.save
      # So instead just use raw SQL:
      item.raw_update(item.lane.project.id)
    end
  end

  def self.down
  end
end
