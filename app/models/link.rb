class Link
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :url
  field :name
  field :tags
  field :comments
  field :clicks, :type => Integer
  field :last_clicked_on, :type => Date
  field :expires_on, :type => Date

  belongs_to :person
  
  validates_presence_of :url, :name

  def get_description
    self.name + (self.comments ? " - #{self.comments}" : '')
  end
end
