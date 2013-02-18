class Workout
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :location
  field :race
  field :description
  field :duration, :type => Integer
  field :intensity, :type => Integer
  field :weight, :type => Integer
  field :distance, :type => Float
  field :workout_on, :type => Date
  #field :route_id
  #field :workout_type_id

  belongs_to :person
  
  belongs_to :workout_type, class_name: "Lookup"
  belongs_to :route, class_name: "Lookup"
  
  validates_presence_of :location, :duration, :workout_on
  
  #def workout_type=(id)
  #  write_attribute(:workout_type, Lookup.find(id)) unless id.empty?
  #end
  
  #def route=(id)
  #  write_attribute(:route, Lookup.find(id)) unless id.empty?
  #end
  
  def self.recent_workouts(user, days)
    user.workouts.where(:workout_on.gte => Date.today - days)
  end
  
  def self.days_with_workouts?(user,days)
    user.workouts.and({:workout_on.gte => Date.today - days}, {:workout_on.lt => Date.today + 1}).distinct(:workout_on).count
  end
  
  def self.workout_duration_by_type(user,days)
    result_hash = Hash.new
    for w in recent_workouts(user,days)
        if (w.workout_type)
          key = w.workout_type.description
          result_hash[key] ||= 0
          result_hash[key] = result_hash[key] + w.duration
        end
    end
    result_hash.sort{|a,b| b[1]<=>a[1]}
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
