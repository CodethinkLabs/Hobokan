class ProjectMembersAdmins < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.logger = Logger.new(STDERR)
    ProjectMember.all.each do |m|
      m.administrator = true
      m.save
    end
  end

  def self.down
  end
end
