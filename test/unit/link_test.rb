require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Link.new
    assert !a.save, 'saved without person'
    a.person= people(:adam)

    assert !a.save, 'saved without url'
    a.url= 'www.nba.com'
    
    assert !a.save, 'saved without name'
    a.name= 'nba'

    assert a.save, 'save with all required fields'
  end
  
end
