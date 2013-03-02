class Workout
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :loc, as: :location
  field :rc, as: :race
  field :dsc, as: :description
  field :dur, as: :duration, :type => Integer
  field :int, as: :intensity, :type => Integer
  field :wt, as: :weight, :type => Integer
  field :di, as: :distance, :type => Float
  field :w_on, as: :workout_on, :type => Date

  belongs_to :person
  belongs_to :workout_type, class_name: "Lookup"
  belongs_to :route, class_name: "Lookup"

  validates_presence_of :location, :duration, :workout_on

  attr_accessible :person, :location, :race, :description, :duration, :intensity, :weight, :distance, :workout_on, :workout_type, :route

  def self.recent_workouts(user, days)
    user.workouts.where(:workout_on.gte => Date.today - days)
  end

  def self.days_with_workouts?(user,days)
    user.workouts.and({:workout_on.gte => Date.today - days}, {:workout_on.lt => Date.today + 1}).distinct(:workout_on).count
  end

  def self.workout_duration_by_type(user,days)
    types = Hash.new
    total_duration = 0
    workouts = recent_workouts(user,days)
    workouts.each do |w|
      if w.workout_type
        total_duration += w.duration 
        if types.has_key?(w.workout_type.description)
           types[w.workout_type.description]['duration'] += w.duration
        else
          types[w.workout_type.description] = { 'duration' => w.duration }
        end
      end
    end
    types.values.each do |type|
      type['percentage'] = ((type['duration']/total_duration.to_f) * 100).to_i || 1
    end
    types.sort{|a,b| b[1]['duration']<=>a[1]['duration']}
  end

  def self.summary(user,days)
    workouts = Workout.recent_workouts(user,days)
    mileage = 0
    duration = 0
    max_weight = 0
    min_weight = 999
    for w in workouts
      mileage += w.distance if w.distance
      duration += w.duration if w.duration
      max_weight = w.weight if w.weight and w.weight > max_weight
      min_weight = w.weight if w.weight and w.weight < min_weight
    end
    {
      weight_range: "#{min_weight}-#{max_weight}",
      workout_days: Workout.days_with_workouts?(user,days),
      mileage: (mileage*10).ceil/10.0, # tenths of kms
      duration: (duration/60*10).ceil/10.0 # minutes to tenths of hours
    }
  end
end
