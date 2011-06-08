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
  
  attr_accessor :auth_profile

  def self.authenticate(name, password)
    profile = nil
    resp = nil
    url = "#{APP_CONFIG['auth_host']}/users.xml?user_name=#{name}&password=#{password}"
    logger.debug("Person.authenticate: authenticating with url[#{url}]...")
    open(url) do |http|
      resp = http.read
    end
    logger.debug("Person.authenticate: resp[#{resp}]...")
    
    if !resp.empty?
      root = REXML::Document.new(resp).root
      user_name = root.elements["user/user-name"].text
      logger.info("user_name = #{user_name}")
      user = Person.find_by_user_name(user_name)
      if user
        #name = (root.elements["name"].text) if root.elements["name"].text
        authority = (root.elements["user/authority"].text.to_i) if root.elements["user/authority"].text
        born_on = (Date.parse(root.elements["user/born-on"].text)) if root.elements["user/born-on"].text
        profile = AuthProfile.new(user.id, name, authority, born_on)
      end
    end
    profile
  end
    
  def age_in_days?
    Date.today - auth_profile.born_on
  end
  
  def age_in_years?
    y = Date.today.year - auth_profile.born_on.year
    y -= 1 if (Date.today.yday < auth_profile.born_on.yday)
    y
  end
    
  def days_left?
    #based on 84 year life expectancy 
    (auth_profile.born_on>>(84*12)) - Date.today
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
  
  def name?
    auth_profile.name ? auth_profile.name : user_name
  end
  
end
