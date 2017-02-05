require 'strava/api/v3'

module Brainpad
  class StravaLib

    def self.import_for(person, page_size = 100)
      @client = Strava::Api::V3::Client.new(access_token: STRAVA_ACCESS_TOKEN)
      activities = @client.list_athlete_activities(per_page: page_size)
      created_count = 0
      existing_count = 0
      activities.each do |w|
        strava_id = w['id']

        # if we already have a workout with this strava_id, we're done.
        # the activities are sorted by recent first so as soon as we find one we already have,
        # we'll also have all older activities. if the sorting ever changes, change the next
        # line to `next` instead of `break`
        break if Workout.find_by(strava_id: strava_id)

        detailed_activity = @client.retrieve_an_activity(strava_id)
        existing = Workout.find_by(strava_id: strava_id)
        if existing
          p "workout found with #{strava_id}"
          existing_count += 1
        else
          p "create a workout for strava_id: #{strava_id}"
          create_workout_for(person, params_for(detailed_activity))
          created_count += 1
        end
      end
      p "created #{created_count} workouts."
      p "#{existing_count} workouts already existed."
    end

    private

    def self.create_workout_for(person, params)
      new_workout = Workout.new(params)
      new_workout.person = person
      new_workout.save
      if new_workout.valid?
        p "created: #{new_workout.description[0..30]}"
      else
        p "failed to create: #{new_workout.errors.inspect}"
      end
    end

    def self.params_for(strava_activity)
      {
        strava_id: strava_activity['id'],
        location: location_for(strava_activity),
        intensity: intensity_for(strava_activity),
        duration: duration_for(strava_activity),
        distance: distance_for(strava_activity),
        description: description_for(strava_activity),
        workout_on: strava_activity['start_date'],
        tags: tags_for(strava_activity)
      }
    end

    def self.description_for(strava_activity)
      desc = strava_activity['description']
      # remove intensity tags
      desc.gsub!(/int\[(\d\.?\d?)\]/, '') if desc
      # remove location tags
      desc.gsub!(/loc\[(.*?)\]/, '') if desc
      "#{strava_activity['name']}. #{desc}".strip
    end

    def self.duration_for(strava_activity)
      (strava_activity['elapsed_time'] / 60).round if strava_activity['elapsed_time']
    end

    def self.distance_for(strava_activity)
      (strava_activity['distance'] / 1000).round(1) if strava_activity['distance']
    end

    def self.tags_for(strava_activity)
      strava_activity['name'].start_with?('tennis') ? 'tennis' : strava_activity['type'].downcase
    end

    def self.intensity_for(strava_activity)
      intensity_match = /int\[(\d\.?\d?)\]/.match(strava_activity['description'])
      intensity_match[1] if intensity_match
    end

    def self.location_for(strava_activity)
      location_match = /loc\[(.*)\]/.match(strava_activity['description'])
      return location_match[1] if location_match
      'unknown'
    end
  end
end
