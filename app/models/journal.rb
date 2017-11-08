class Journal
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :en, as: :entry
  field :tg, as: :tags
  field :e_on, as: :entry_on, type: Date

  belongs_to :person
  belongs_to :journal_type, class_name: 'Lookup', optional: true

  validates :entry, presence: true
  validates :entry_on, presence: true
  paginates_per 15

  def to_s
    entry[0, 30]
  end
end
