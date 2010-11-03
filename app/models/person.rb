require 'open-uri'

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
    url = "#{APP_CONFIG['auth_host']}/users/find.xml?user_name=#{name}&password=#{password}"
    logger.debug("Person.authenticate: authenticating with url[#{url}]...")
    open(url) do |http|
      http.read
    end
  end
  
  def self.find_id_by_user_name(user_name)
    user = Person.find_by_user_name(user_name)
    logger.info("person.find_id_by_user_name id found: #{user.id}")
    user ? user.id : 0
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
