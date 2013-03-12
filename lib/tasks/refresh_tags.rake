desc "refresh the tag_lists tag summary for each user"

task :refresh_tags => :environment do
  Person.all.each do |user|
    %w[connections contacts journals links payments reminders].each do |type|
      entities = eval "user.#{type}"
      entities.each do |entity| 
        user.tag(type, entity.tags) unless entity.tags.blank?
      end
      count = user.tags_for(type) ? user.tags_for(type).count : 0
      puts "processed #{count} #{type} tags for #{user.username}"
    end
  end
end