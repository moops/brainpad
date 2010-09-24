require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Payment.new
    assert !a.save, 'saved without person'
    a.person= people(:adam)

    assert !a.save, 'saved without account'
    a.account= accounts(:chequing)

    assert !a.save, 'saved without amount'
    a.amount= 25
    
    assert !a.save, 'saved without payment date'
    a.payment_on= Date.today

    assert a.save, 'save with all required fields'
  end
  
end
