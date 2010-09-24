class Connection < ActiveRecord::Base

  belongs_to :person
  
  validates_presence_of :person, :username, :password, :url
  
end
