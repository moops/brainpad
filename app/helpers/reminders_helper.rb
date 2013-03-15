module RemindersHelper
  
  def due_with_class(reminder)
    if reminder.due_on < Date.today 
      due_class = 'overdue'
    elsif reminder.due_on == Date.today
      due_class = 'due'
    else
      due_class = ''
    end
    content_tag(:div, reminder.due_on.strftime("%a %b %d, %y"), class: due_class)
  end
end