class Reminder
  include Mongoid::Document
  
  field :description
  field :done, :type => Boolean
  field :priority, :type => Integer
  field :reminder_type, :type => Integer
  field :frequency, :type => Integer
  field :repeat_until, :type => Date
  field :due_on, :type => Date
  field :person_id, :type => Integer
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime

  belongs_to :person
  
  validates_presence_of :person, :description, :due_on
  
  def self.search(condition_params, page)
    condition_params[:q] = "%#{condition_params[:q]}%"
    logger.debug("Reminder::search condition_params[#{condition_params.inspect}]")
    Reminder.paginate :page => page, :conditions => get_search_conditions(condition_params), :order => 'due_on', :per_page => 13
  end
  
  def self.get_search_conditions(condition_params)
    conditions = []
    query = 'reminders.person_id = :user and not done'
    query << ' and reminders.description like :q' unless condition_params[:q].blank?
    if !condition_params[:start_on].blank? && !condition_params[:end_on].blank?
      query << ' and reminders.due_on between :start_on and :end_on'
    elsif !condition_params[:start_on].blank?
      query << ' and reminders.due_on >= :start_on'
    elsif !condition_params[:end_on].blank?
      query << ' and reminders.due_on <= :end_on'
    end
    logger.debug("Reminder::get_search_conditions query[#{query}]")
    conditions << query
    conditions << condition_params
  end
  
  def done?
    !(done == 0 or done == 'f') 
  end
  
  def self.todays(person_id)
    Reminder.find(:all, :conditions => "person_id = #{person_id} and due_on = '#{Date.today}' and not done")
  end
  
  def self.recent_reminders(user, days)
    Reminder.find(:all, :conditions => [ "person_id = ? and due_on > ?", user.id, Date.today - (days + 1) ])
  end
  
end
