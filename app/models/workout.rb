class Workout
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :location
  field :race
  field :route, :type => Integer
  field :description
  field :duration, :type => Integer
  field :intensity, :type => Integer
  field :weight, :type => Integer
  field :distance, :type => Float
  field :workout_type, :type => Integer
  field :workout_on, :type => Date

  belongs_to :person
  
  validates_presence_of :location, :duration, :workout_on
  
  def self.search(condition_params, page)
    condition_params[:q] = "%#{condition_params[:q]}%"
    Workout.paginate :page => page, :conditions => get_search_conditions(condition_params), :order => 'workout_on desc', :per_page => 13
  end
  
  def self.recent_workouts(user, days)
    user.workouts.where(:workout_on.gte => Date.today - days)
  end
  
  def self.days_with_workouts?(user,days)
    user.workouts.and({:workout_on.gte => Date.today - days}, {:workout_on.lt => Date.today + 1}).distinct(:workout_on).count
  end
  
  def self.workout_duration_by_type(user,days)
    result_hash = Hash.new
    for w in recent_workouts(user,days)
        key = Lookup.find('511d63deffc2f99e59000003').description
        result_hash[key] ||= 0
        result_hash[key] = result_hash[key] + w.duration
    end
    result_hash.sort{|a,b| b[1]<=>a[1]}
  end
  
  def self.get_search_conditions(condition_params)
    conditions = []
    query = 'workouts.person_id = :user'
    query << ' and workouts.location like :q' unless condition_params[:q].blank?
    query << ' and workouts.workout_type = :type' unless condition_params[:type].blank?
    if !condition_params[:start_on].blank? && !condition_params[:end_on].blank?
      query << ' and workouts.workout_on between :start_on and :end_on'
    elsif !condition_params[:start_on].blank?
      query << ' and workouts.workout_on >= :start_on'
    elsif !condition_params[:end_on].blank?
      query << ' and workouts.workout_on <= :end_on'
    end
    logger.debug("Workout::get_search_conditions query[#{query}]")
    conditions << query
    conditions << condition_params
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
      mileage: mileage,
      duration: duration
    }
  end
  
end
