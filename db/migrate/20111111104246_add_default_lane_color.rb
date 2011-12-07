class AddDefaultLaneColor < ActiveRecord::Migration
  def self.up
    change_column :lanes, :color, :string, :limit => 255, :default => "#000000"

    # ActiveRecord::Base.logger = Logger.new(STDERR)
    Lane.all.each do |lane|
      if lane.color.blank?
        lane.color = '#000000'
        lane.save
      end
    end
  end

  def self.down
    change_column :lanes, :color, :string
  end
end
