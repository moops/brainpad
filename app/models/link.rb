class Link < ActiveRecord::Base

  belongs_to :person

  def get_description
    self.name + (self.comments ? " - #{self.comments}" : '')
  end
end
