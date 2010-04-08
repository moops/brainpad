class Link < ActiveRecord::Base

  belongs_to :person

  def get_description
    description = self.name
    if self.comments
      description << " - #{self.comments}"
    end
    description
  end
end
