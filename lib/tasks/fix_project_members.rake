namespace :db do
  desc "This task is called by the Heroku scheduler add-on"
  task :pm => :environment do
    ItemAssignment.all.each do |i|
      p = ProjectMember.find(i.user_id)
      i.user_id = p.user_id
      i.save
    end
  end
end
