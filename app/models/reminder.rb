class Reminder
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  
  field :dsc, as: :description
  field :tg, as: :tags
  field :dn, as: :done, :type => Boolean
  field :r_un, as: :repeat_until, :type => Date
  field :d_on, as: :due_on, :type => Date

  belongs_to :person
  belongs_to :reminder_type, class_name: "Lookup"
  belongs_to :priority, class_name: "Lookup"
  belongs_to :frequency, class_name: "Lookup"
  
  validates_presence_of :description, :due_on
  
  scope :outstanding, where(done: false)
  
  def done?
    !(done == 0 or done == 'f') 
  end
  
  def description_condensed
    description.length > 40 ? "#{description[0,40]}..." : description
  end
  
  def self.todays(user)
    user.reminders.where(due_on: Date.today, done: false)
  end
  
  def self.recent(user, days)
    user.reminders.gt(due_on: Date.today - (days + 1))
  end
  
  def self.summary(user,days)
    reminders = Reminder.recent(user,days)
    created = reminders.length
    completed = 0
    on_time = 0
    reminders.each do |r|
      completed += 1 if r.done
      on_time += 1 if r.done and r.due_on > r.updated_at.to_date
    end
    completion_rate = (completed.to_f / created.to_f) * 100
    {
      created: created,
      on_time: on_time,
      completed: completed,
      completion_rate: created > 0 ? (completed.to_f / created.to_f) * 100 : 0
    }
  end
end