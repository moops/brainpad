class Connection
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :username
  field :password
  field :url
  field :description
  field :tags

  belongs_to :person
  
  validates_presence_of :username, :password, :url

  
end
