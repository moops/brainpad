class Journal
  include Mongoid::Document
  include Mongoid::Timestamps

  field :entry
  field :entry_on, :type => Date

  belongs_to :person
  belongs_to :journal_type, class_name: "Lookup"

  validates_presence_of :entry, :entry_on
end