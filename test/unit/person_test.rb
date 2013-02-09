require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  
  test "save without required username" do
    a = Person.new
    assert !a.save, 'saved without username'
  end
  
  test "save with required username" do
    b = build(:person)
    assert b.save, "save with all required fields #{b.inspect}"
  end
  
  
  test "unique username" do
    a = build(:person, username: 'test')
    b = build(:person, username: 'test')
    assert a.save, 'username is unique'
    assert !b.save, 'username not unique'
  end
  
end
