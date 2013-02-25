class Link
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  
  field :url
  field :nm, as: :name
  field :tg, as: :tags
  field :cm, as: :comments
  field :cl, as: :clicks, :type => Integer
  field :l_on, as: :last_clicked_on, :type => Date
  field :e_on, as: :expires_on, :type => Date

  belongs_to :person
  
  validates_presence_of :url, :name

  def get_description
    self.name + (self.comments ? " - #{self.comments}" : '')
  end
end
