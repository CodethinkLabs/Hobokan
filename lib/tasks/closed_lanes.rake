desc "Set closed lane"
task :closed_lanes => :environment do
  Lane.find_each do |lane|
    if (lane.title == "Done") or (lane.title == "Not Going To Fix") or (lane.title == "DO NOT DELETE ME")
      lane.closed = true
      puts lane.id.to_s + " " + lane.title
      lane.save
    end
  end
end