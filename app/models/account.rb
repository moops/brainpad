class Account
  include Mongoid::Document
  
  field :name, type: String
  field :url, type: String
  field :price_url, type: String
  field :description, type: String
  field :units, type: Float
  field :price, type: Float
  field :active, type: Boolean
  field :person_id, type: Integer
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

  belongs_to :person
  has_many :payments
  
  validates_presence_of :person, :name, :units, :price
  
  attr_accessor :balance
  
  def balance?
    units * price
  end
  
end
