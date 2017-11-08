class Milestone
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :nm, as: :name
  field :m_at, as: :milestone_at, type: Date

  belongs_to :person

  validates :name, presence: true
  validates :milestone_at, presence: true
  paginates_per 15

  def self.next_milestone(_person_id)
    Milestone.gt(milestone_at: Time.zone.now).asc('milestone_at').first
  end
end
