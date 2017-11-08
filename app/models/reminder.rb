class Reminder
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :dsc, as: :description
  field :tg, as: :tags
  field :dn, as: :done, type: Boolean, default: false
  field :r_un, as: :repeat_until, type: Date
  field :d_at, as: :due_at, type: DateTime

  belongs_to :person
  belongs_to :reminder_type, class_name: 'Lookup', optional: true
  belongs_to :priority, class_name: 'Lookup', optional: true
  belongs_to :frequency, class_name: 'Lookup', optional: true

  validates :description, presence: true
  validates :due_at, presence: true
  paginates_per 8

  scope :outstanding, -> { where(done: false) }

  def done?
    !(done.zero? || done == 'f')
  end

  def self.todays(user)
    user.reminders.where(
      done: false, :due_at.gte => Time.zone.now.beginning_of_day, :due_at.lte => Time.zone.now.end_of_day
    )
  end

  def self.recent(user, days)
    user.reminders.gt(due_at: Time.zone.today - (days + 1))
  end

  def self.describe_due(user, at = Time.zone.now)
    summary = "due today:\n"
    user.reminders.where(done: false, :due_at.gte => at.beginning_of_day, :due_at.lte => at.end_of_day).each do |r|
      summary << "- #{r.priority.description} " if r.priority
      summary << "- #{r.description}\n"
    end
    summary
  end

  def self.summary(user, days)
    reminders = Reminder.recent(user, days)
    created = reminders.length
    completed = 0
    on_time = 0
    reminders.each do |r|
      completed += 1 if r.done
      on_time += 1 if r.done && r.due_at > r.updated_at.to_date
    end
    _completion_rate = (completed.to_f / created.to_f) * 100 # might use this later
    {
      created: created,
      on_time: on_time,
      completed: completed,
      completion_rate: created > 0 ? (completed.to_f / created.to_f) * 100 : 0
    }
  end

  def to_s
    "#{due_at} - #{description}"
  end
end
