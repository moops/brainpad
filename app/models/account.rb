class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :url
  field :price_url
  field :description
  field :units, :type => Float
  field :price, :type => Float
  field :active, :type => Boolean

  belongs_to :person
  #has_many :payments
  
  validates_presence_of :name, :units, :price
  
  attr_accessor :balance
  
  def balance?
    units * price
  end
  
end
