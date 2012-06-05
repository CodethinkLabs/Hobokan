namespace :db do
  desc "Fix for refactoring from project_member to user"
  task :pm => :environment do
    ItemAssignment.all.each do |i|
      p = ProjectMember.find(i.user_id)
      i.user_id = p.user_id
      i.save
    end
  end
end
