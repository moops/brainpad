class Workout
  include Mongoid::Document
  
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
  field :person_id, :type => Integer
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime

  belongs_to :person
  
  validates_presence_of :person, :location, :duration, :workout_on
  
  def self.search(condition_params, page)
    condition_params[:q] = "%#{condition_params[:q]}%"
    logger.debug("Workout::search condition_params[#{condition_params.inspect}]")
    Workout.paginate :page => page, :conditions => get_search_conditions(condition_params), :order => 'workout_on desc', :per_page => 13
  end
  
  def self.recent_workouts(user, days)
    Workout.find(:all, :conditions => [ "person_id = ? and workout_on > ?", user.id, Date.today - (days + 1) ])
  end
  
  def self.days_with_workouts?(user,days)
    ActiveRecord::Base.connection.select_one("select count( distinct workout_on) as s from workouts where person_id = #{user.id} and workout_on between '#{Date.today - days}' and '#{Date.today+(1)}'")['s'].to_i
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
  
end
