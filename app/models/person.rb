require 'open-uri'
require 'rexml/document'

class Person < ActiveRecord::Base

  has_many :accounts
  has_many :connections
  has_many :contacts
  has_many :journals
  has_many :links
  has_many :reminders
  has_many :workouts
  
  validates_presence_of :user_name
  
  attr_accessor :name, :authority, :born_on

  def self.authenticate(name, password)
    user = nil
    resp = nil
    url = "#{APP_CONFIG['auth_host']}/users/find.xml?user_name=#{name}&password=#{password}"
    logger.debug("Person.authenticate: authenticating with url[#{url}]...")
    open(url) do |http|
      resp = http.read
    end
    logger.debug("Person.authenticate: resp[#{resp}]...")
    
    if !resp.empty?
      root = REXML::Document.new(resp).root
      user = Person.find_by_user_name(root.elements["user-name"].text)
      if user
        user.name=(root.elements["name"].text)
        user.authority=(root.elements["authority"].text.to_i)
        user.born_on=(Date.parse(root.elements["born-on"].text))
      end
    end
    user
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
