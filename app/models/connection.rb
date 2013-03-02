class Connection
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  
  field :nm, as: :name
  field :un, as: :username
  field :pw, as: :password
  field :url
  field :dsc, as: :description
  field :tg, as: :tags

  belongs_to :person

  validates_presence_of :username, :password, :url

  attr_accessible :person, :name, :username, :password, :url, :description, :tags

end
