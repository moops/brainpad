class Journal
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :en, as: :entry
  field :tg, as: :tags
  field :e_on, as: :entry_on, type: Date

  belongs_to :person
  belongs_to :journal_type, class_name: "Lookup"

  validates_presence_of :entry, :entry_on

  attr_accessible :entry, :tags, :entry_on, :journal_type_id
end