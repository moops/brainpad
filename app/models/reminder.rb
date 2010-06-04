class Reminder < ActiveRecord::Base

  belongs_to :person
  
  def done?
    !(done == 0 or done == 'f') 
  end
  
  def self.todays(person_id)
    Reminder.find(:all, :conditions => "person_id = #{person_id} and due_on = '#{Date.today}' and not done")
  end
  
end
