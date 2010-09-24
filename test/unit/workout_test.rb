require 'test_helper'

class WorkoutTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Workout.new
    assert !a.save, 'saved without person'
    a.person= people(:adam)
    
    assert !a.save, 'saved without location'
    a.location= 'victoria waterfront'

    assert !a.save, 'saved without duration'
    a.duration= '25'
    
    assert !a.save, 'saved without workout date'
    a.workout_on= Date.today

    assert a.save, 'save with all required fields'
  end
  
end
