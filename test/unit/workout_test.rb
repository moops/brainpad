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
  
  test "recent workouts" do
    should_be_one = Workout.recent_workouts(people(:adam), 3)
    assert should_be_one.length == 1, "should be 1 workouts in the last 3 days, but was #{should_be_one.length}"
    
    should_be_three = Workout.recent_workouts(people(:adam), 6)
    assert should_be_three.length == 3, "should be 3 workouts in the last 6 days, but was #{should_be_three.length}"
  end
  
end
