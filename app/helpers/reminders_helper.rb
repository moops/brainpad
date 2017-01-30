module RemindersHelper

  def due_with_class(reminder)
    if reminder.due_at.to_time < Time.now
      due_class = 'overdue'
    elsif reminder.due_at == Time.now
      due_class = 'due'
    else
      due_class = ''
    end
    content_tag(:div, reminder.due_at.strftime("%a %b %d, %y"), class: due_class)
  end
end
