class Milestone
  include Mongoid::Document
  
  field :name, type: String
  field :milestone_at, type: Date
  field :person_id, type: Integer
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

  belongs_to :person
  
  validates_presence_of :name, :milestone_at
  
  def self.next_milestone(person)
    first(:conditions => [ "person_id = ? AND milestone_at > ?", person.id, Time.now ], :order => "milestone_at")
  end
  
end
