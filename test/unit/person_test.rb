require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Person.new
    assert !a.save, 'saved without user_name'
    a.user_name= 'fred'

    assert a.save, 'save with all required fields'
  end
  
  test "test authenticate" do
    #todo
    assert true
  end
  
  test "test name" do
    a = Person.new(:user_name => 'test')
    profile = AuthProfile.new(1, 'test user', 1, '2000-01-01')
    a.auth_profile = profile
    assert a.name?.eql?('test user'), 'full name from auth_profile not being used'
    a.auth_profile.name = nil
    assert a.name?.eql?('test'), 'full name is nil, user_name should be used'
  end
  
  test "age in days" do
    #6580 days old
    a = Person.new(:user_name => 'test')
    profile = AuthProfile.new(1, 'test user', 1, Date.today-(6580))
    a.auth_profile = profile
    assert a.age_in_days? == (6580), "age[#{a.age_in_days?}] is not 6580"
    
    #6565 days old
    a = Person.new(:user_name => 'test')
    profile = AuthProfile.new(1, 'test user', 1, Date.today-(6565))
    a.auth_profile = profile
    assert a.age_in_days? == (6565), "age[#{a.age_in_days?}] is not 6565"
  end
  
  test "age in years" do
    twenty_years_ago = Date.today<<(240)
    #20 years old yesterday (age should be 20)
    born_on = twenty_years_ago-(1)
    a = Person.new(:user_name => 'test')
    profile = AuthProfile.new(1, 'test user', 1, born_on)
    a.auth_profile = profile
    assert a.age_in_years? == (20), "age[#{a.age_in_years?}] is not 20"

    #20 years old tommorow (age should be 19)
    born_on = twenty_years_ago+(1)
    a = Person.new(:user_name => 'test')
    profile = AuthProfile.new(1, 'test user', 1, born_on)
    a.auth_profile = profile
    assert a.age_in_years? == (19), "age[#{a.age_in_years?}] is not 19"
  end
  
end
