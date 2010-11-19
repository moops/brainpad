class Workout < ActiveRecord::Base

  belongs_to :person
  
  validates_presence_of :person, :location, :duration, :workout_on
  
  def self.recent_workouts(user, days)
    Workout.find(:all, :conditions => [ "person_id = ? AND workout_on > ?", user.id, Date.today - (days + 1) ])
  end
  
  def self.days_with_workouts?(user,days)
    ActiveRecord::Base.connection.select_one("SELECT count( distinct workout_on) as s FROM workouts WHERE person_id = #{user.id} and workout_on between '#{Date.today - days}' and '#{Date.today+(1)}'")['s'].to_i
  end
  
  def self.workout_duration_by_type(user,days)
    result_hash = Hash.new
    for w in recent_workouts(user,days)
        key = Lookup.find(w.workout_type).description
        result_hash[key] ||= 0
        result_hash[key] = result_hash[key] + w.duration
    end
    result_array = result_hash.sort{|a,b| b[1]<=>a[1]}
  end
  
end
