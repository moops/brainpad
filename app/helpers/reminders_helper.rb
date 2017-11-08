module RemindersHelper
  def due_with_class(reminder)
    due_class = if reminder.due_at.to_time < Time.zone.now
                  'overdue'
                elsif reminder.due_at == Time.zone.now
                  'due'
                else
                  ''
                end
    content_tag(:div, reminder.due_at.strftime('%a %b %d, %y'), class: due_class)
  end
end
