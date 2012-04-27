class Milestone
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :milestone_at, :type => Date

  belongs_to :person
  
  validates_presence_of :name, :milestone_at
  
  def self.next_milestone(person)
    first(:conditions => [ "person_id = ? AND milestone_at > ?", person.id, Time.now ], :order => "milestone_at")
  end
  
end
