class Contact < ActiveRecord::Base

  belongs_to :person
  
  validates_presence_of :person, :name
  
end
