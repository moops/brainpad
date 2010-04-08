class Person < ActiveRecord::Base

  
  has_many :accounts
  has_many :connections
  has_many :contacts
  has_many :journals
  has_many :links
  has_many :reminders
  has_many :workouts

  def self.authenticate(name, password)
    Person.find(:first, :conditions => [ "user_name = ? and password = ?", name, password ])
  end
    
  def get_age
    Date.today - birth_on
  end
    
  def get_days_left
    #based on 84 year life expectancy 
    (birth_on>>(84*12)) - Date.today
  end
    
  def active_accounts
    accounts.reject { |a| not a.active }
  end
  
  def active_schedules
    schedules.reject { |s| s.start_on > Date.today or s.end_on < Date.today }
  end
  
  def payments
    p = Array.new
    for a in active_accounts
      p += a.payments
    end
    p
  end
  
end
