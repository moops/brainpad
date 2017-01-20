require 'test_helper'

class WorkoutTest < ActiveSupport::TestCase
  let(:adam) { Person.find_by(username: 'adam') }
  let(:cate) { Person.find_by(username: 'cate') }

  it 'fails to save without required fields' do
    workout = Workout.new
    refute workout.save, 'saved without person'
    workout.person = cate

    refute workout.save, 'saved without location'
    workout.location = 'victoria waterfront'

    refute workout.save, 'saved without duration'
    workout.duration = '25'

    refute workout.save, 'saved without workout date'
    workout.workout_on = Date.today

    assert workout.save, 'save with all required fields'
  end

  it 'finds recent workouts' do
    should_be_one = Workout.recent_workouts(adam, 3)
    assert_equal 1, should_be_one.count

    should_be_three = Workout.recent_workouts(adam, 6)
    assert_equal 3, should_be_three.count
  end
end
