class Account < ActiveRecord::Base

  belongs_to :person
  has_many :payments
  
  validates_presence_of :person, :name, :units, :price
  
  attr_accessor :balance
  
  def balance?
    units * price
  end
  
end
