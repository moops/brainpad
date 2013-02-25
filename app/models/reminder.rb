class Reminder
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description
  field :tags
  field :done, :type => Boolean
  field :repeat_until, :type => Date
  field :due_on, :type => Date

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

  def self.due_on_for(user, on=Date.today)
    user.reminders.where(due_on: on, done: false)
  end

  def self.recent(user, days=30)
    user.reminders.gt(due_on: Date.today - (days + 1))
  end

  def self.describe_due(user, on=Date.today)
    summary = "due today:\n"
    user.reminders.where(due_on: on, done: false).each do |r|
      summary << "- #{r.priority.description} " if r.priority
      summary << "- #{r.description}\n"
    end
    summary
  end

  def self.summary(user, days)
    reminders = Reminder.recent(user,days)
    created = [reminders.length, 1].max
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
      completion_rate: (completed.to_f / created.to_f) * 100
    }
  end
end