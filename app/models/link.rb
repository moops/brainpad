class Link
  include Mongoid::Document
  
  field :url, type: String
  field :name, type: String
  field :tags, type: String
  field :comments, type: String
  field :clicks, type: Integer
  field :last_clicked, type: DateTime
  field :expires_on, type: DateTime
  field :person_id, type: Integer
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

  belongs_to :person
  
  validates_presence_of :person, :url, :name

  def get_description
    self.name + (self.comments ? " - #{self.comments}" : '')
  end
end
