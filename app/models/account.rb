class Account < ActiveRecord::Base

  belongs_to :person
  has_many :payments
  
  def adjust!(old_amount,new_amount)
    diff = new_amount - old_amount
    self.units += (diff / self.price)
    self.save
  end
  
end
