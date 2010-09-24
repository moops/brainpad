require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Contact.new
    assert !a.save, 'saved without person'
    a.person= people(:adam)

    assert !a.save, 'saved without name'
    a.name= 'fred flintstone'

    assert a.save, 'save with all required fields'
  end
  
end
