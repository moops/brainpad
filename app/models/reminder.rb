class Reminder
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :dsc, as: :description
  field :tg, as: :tags
  field :dn, as: :done, type: Boolean, default: false
  field :r_un, as: :repeat_until, type: Date
  field :d_at, as: :due_at, type: DateTime

  belongs_to :person
  belongs_to :reminder_type, class_name: 'Lookup'
  belongs_to :priority, class_name: 'Lookup'
  belongs_to :frequency, class_name: 'Lookup'

  validates_presence_of :description, :due_at

  attr_accessible :description, :tags, :done, :repeat_until, :due_at, :reminder_type_id, :priority_id, :frequency

  scope :outstanding, where(done: false)

  def done?
    !(done == 0 or done == 'f')
  end

  def self.todays(user)
    user.reminders.where(due_at: Date.today, done: false)
  end

  def self.recent(user, days)
    user.reminders.gt(due_at: Date.today - (days + 1))
  end

  def self.describe_due(user, on=Date.today)
    summary = "due today:\n"
    user.reminders.where(due_at: on, done: false).each do |r|
      summary << "- #{r.priority.description} " if r.priority
      summary << "- #{r.description}\n"
    end
    summary
  end

  def self.summary(user,days)
    reminders = Reminder.recent(user,days)
    created = reminders.length
    completed = 0
    on_time = 0
    reminders.each do |r|
      completed += 1 if r.done
      on_time += 1 if r.done and r.due_at > r.updated_at.to_date
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