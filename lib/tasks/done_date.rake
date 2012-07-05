desc "Set end_date of items"
task :done_date => :environment do
  Version.find_each do |v|
    if v.modifications.include? 'lane_id'
      if v.versioned_id > 0
        item = Item.find(v.versioned_id)
        puts item.id.to_s + item.title
        item.end_date = v.created_at.to_date
        item.save
      end
    end
  end
end
