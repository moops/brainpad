# this requires that a workout have a workout_type relationship with lookup.
# that is what we're trying to replace with workout.tags so after this is run
# to move the data, workout_type needs to be deleted from the code (from both
# workout and lookup)

desc 'migrate workout.type to workout.tags for each user'

task migrate_workout_type_to_tags: :environment do
  Person.all.each do |user|
    puts "processing #{user.workouts.size} workouts for #{user.username}..."
    if user.workouts
      user.workouts.each do |workout|
        # set the new tags field based on the existing workout_type
        if workout.workout_type && 'other'.eql?(workout.workout_type.description)
          # if the type is 'other' look into the description
          workout.tags = if workout.location.include?('home')
                           'home'
                         elsif workout.description.include?('tennis')
                           'tennis'
                         elsif workout.description.include?('soccer')
                           'soccer'
                         else
                           'other'
                         end
        else
          workout.tags = workout.workout_type ? workout.workout_type.description : 'other'
        end
        workout.save
        user.tag('workout', workout.tags) if workout.tags.present?
      end
    end
    count = user.tags_for('workout') ? user.tags_for('workout').count : 0
    puts "processed #{count} workout tags for #{user.username}"
  end
end
