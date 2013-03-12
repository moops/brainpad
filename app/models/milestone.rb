class Milestone
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :nm, as: :name
  field :m_at, as: :milestone_at, :type => Date

  belongs_to :person

  validates_presence_of :name, :milestone_at

  attr_accessible :name, :milestone_at

  def self.next_milestone(person_id)
    Milestone.gt(milestone_at: Time.now).asc('milestone_at').first
  end
  
end
