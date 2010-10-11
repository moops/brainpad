require 'test_helper'

class MilestoneTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Milestone.new
    assert !a.save, 'saved without person'
    a.person= people(:adam)

    assert !a.save, 'saved without name'
    a.name= 'new milestone'

    assert !a.save, 'saved without milestone datetime'
    a.milestone_at= Date.today

    assert a.save, 'save with all required fields'
  end
  
  test "next milestone" do
    assert Milestone.next_milestone(people(:adam)).eql?(milestones(:tomorrow))
  end
  
end
