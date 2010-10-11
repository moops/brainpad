class Milestone < ActiveRecord::Base

  belongs_to :person
  
  validates_presence_of :name, :milestone_at
  
  def self.next_milestone(person)
    first(:conditions => [ "person_id = ? AND milestone_at > ?", person.id, Time.now ], :order => "milestone_at")
  end
  
end
