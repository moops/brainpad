
class Person < ActiveRecord::Base

  has_many :accounts
  has_many :connections
  has_many :contacts
  has_many :journals
  has_many :links
  has_many :reminders
  has_many :workouts
  
  validates_presence_of :user_name

  def self.authenticate(name, password)
    Person.find(:first, :conditions => [ "user_name = ? and password = ?", name, password ])
    #Person.find(:first, :conditions => [ "user_name = ?", name ])
    
    #url = 'http://localhost:3001/users/find.xml?user_name=quinnlawr&password=quinn_pass'
    #open(url) do |http|
    #  response = http.read
    #  logger.info("name #{name} password #{password} response #{response}")
   # end
  end
    
  def get_age
    Date.today - born_on
  end
    
  def get_days_left
    #based on 84 year life expectancy 
    (born_on>>(84*12)) - Date.today
  end
    
  def active_accounts
    a = accounts.reject { |a| not a.active }
    a.sort_by{|a| a.name }
  end
  
  def payments
    p = Array.new
    for a in active_accounts
      p += a.payments
    end
    p
  end
  
end
