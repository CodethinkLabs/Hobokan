desc "Set end_date of items"
task :done_date => :environment do
  Version.find_each do |v|
    if v.modifications.include? 'lane_id'
      if v.versioned_id > 0
        puts v.id.to_s
        puts v.modifications
        item = Item.find(v.versioned_id)
        if item.id != nil && v.user_id
          User.current = User.find(v.user_id)
          puts item.id.to_s + " " + item.title + " " + item.end_date.to_s
          item.end_date = v.created_at.to_date
          puts item.id.to_s + " " + item.title + " " + item.end_date.to_s
          puts "saved item: " + item.id.to_s
        else
          puts "this v is busted..."
          puts v
        end        
      end
    end
  end
end
