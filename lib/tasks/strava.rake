namespace :strava do
  desc 'prepare workouts that aren\'t from strava'
  task prepare: :environment do
    Workout.each do |workout|
      workout.update(strava_id: 'none') unless workout.strava_id
    end
  end

  desc 'import workouts from strava'
  task :import, [:username] => :environment do |_t, args|
    raise 'username required' unless args[:username]
    person = Person.find_by(username: args[:username])
    raise 'person not found' unless person
    Brainpad::StravaLib.import_for(person)
  end
end
