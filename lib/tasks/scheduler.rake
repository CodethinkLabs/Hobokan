desc "This task is called by the Heroku scheduler add-on"
task :snapshot => :environment do
  if Date.today.wday == 0
    Project.all.each do |project|
      project.lanes.each do |lane|
        snapshot = Snapshot.new
        snapshot.count = lane.items.count
        snapshot.lane = lane
        snapshot.save
        snapshot.date = Date.today
        snapshot.save
      end
      project.milestones.each do |milestone|
        project.lanes.each do |lane|
          snapshot = Snapshot.new
          snapshot.milestone = milestone
          snapshot.count = lane.items.apply_scopes(:milestone_is => milestone).count
          snapshot.lane = lane
          snapshot.save
          snapshot.date = Date.today
          snapshot.save 
        end
      end      
    end
  end
end

task :report => :environment do
  Project.all.each do |project|
    project.users.each do |user|
      me = User.find(5)
      UserMailer.report(me, project).deliver
    end
  end
end

task :status => :environment do
  Project.all.each do |project|
    project.users.each do |user|
      if user == User.find(5) and project == Project.find(9)
        UserMailer.status(user, project).deliver
      end
    end
  end
end

