require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Person.new
    assert !a.save, 'saved without user_name'
    a.user_name= 'fred'

    assert a.save, 'save with all required fields'
  end
  
end
