require 'test_helper'

class ConnectionTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Connection.new
    assert !a.save, 'saved without person'
    a.person= people(:adam)

    assert !a.save, 'saved without username'
    a.username= 'gmail'
    
    assert !a.save, 'saved without password'
    a.password= 'quinn'
    
    assert !a.save, 'saved without url'
    a.url= 'www.investorsgroup.ca'

    assert a.save, 'save with all required fields'
  end
  
end
