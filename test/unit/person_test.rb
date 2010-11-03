require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Person.new
    assert !a.save, 'saved without user_name'
    a.user_name= 'fred'

    assert a.save, 'save with all required fields'
  end
  
  test "find id by user name" do
    user_name = people(:adam).user_name
    found_id = Person.find_id_by_user_name(user_name)
    assert found_id > 0, 'found id is different'
  end
  
end
