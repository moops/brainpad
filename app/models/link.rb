class Link < ActiveRecord::Base

  belongs_to :person
  
  validates_presence_of :person, :url, :name

  def get_description
    self.name + (self.comments ? " - #{self.comments}" : '')
  end
end
