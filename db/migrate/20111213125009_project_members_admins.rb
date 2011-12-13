class ProjectMembersAdmins < ActiveRecord::Migration
  def self.up
    ProjectMember.all do |m|
      m.administrator = true
      m.save
    end
  end

  def self.down
  end
end
