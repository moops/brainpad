class Milestone < ActiveRecord::Base

  belongs_to :person
  
  validates_presence_of :name, :milestone_at
  
end
