class Journal < ActiveRecord::Base

  belongs_to :person
  
  validates_presence_of :person, :entry, :entry_on
  
end
