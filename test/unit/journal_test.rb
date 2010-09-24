require 'test_helper'

class JournalTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Journal.new
    assert !a.save, 'saved without person'
    a.person= people(:adam)

    assert !a.save, 'saved without entry'
    a.entry= 'test entry'
    
    assert !a.save, 'saved without entry date'
    a.entry_on= Date.today

    assert a.save, 'save with all required fields'
  end
  
end
