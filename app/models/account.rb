class Account < ActiveRecord::Base

  belongs_to :person
  has_many :payments
  
  attr_accessor :balance
  
  def balance?
    units * price
  end
  
end
