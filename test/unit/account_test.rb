require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  test "save without required fields" do
    a = Account.new
    assert !a.save, 'saved without person'
    a.person= people(:adam)

    assert !a.save, 'saved without name'
    a.name= 'savings'
    
    assert !a.save, 'saved without units'
    a.units= 200
    
    assert !a.save, 'saved without price'
    a.price= 1

    assert a.save, 'save with all required fields'
  end
  
  test "balance" do
    a = Account.new(:person => people(:adam), :name => 'test account', :units => 25, :price => 2)
    assert 50 == a.balance?
  end
end
