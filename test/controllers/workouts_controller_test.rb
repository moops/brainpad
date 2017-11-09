require 'test_helper'

class WorkoutsControllerTest < ActionDispatch::IntegrationTest

  describe 'unauthenticated' do

    it 'should not allow index access' do
      get workouts_path
      assert_redirected_to root_url
    end
  end

  describe 'authenticated' do

    before do
      @user = create(:person)
      login @user
    end

    after do
      @user.destroy
    end

    it 'should not show workouts belonging to others' do
      # create a workout belonging to a new user
      another_workout = create(:workout)
      get workout_path(another_workout)
      assert_redirected_to root_url
      # clean up the new workout and person
      another_workout.person.destroy
    end

    describe 'with a workout' do

      before do
        @user_workout = create(:workout, person: @user)
      end

      after do
        @user_workout.destroy if @user_workout
      end

      it 'should get index' do
        get workouts_path
        assert_response :success
        assert_not_nil assigns(:workouts)
        assert_select 'span.list-title', 'workouts'
      end

      it 'should show workouts belonging current user' do
        get workout_path(@user_workout), xhr: true
        assert_response :success
        assert_select 'h5', /^workout details.*/
      end

      it 'should get edit' do
        get edit_workout_path(@user_workout), xhr: true
        assert_response :success
        assert_select 'h5', /^update workout.*/
      end

      it 'should update workout' do
        put workout_path(@user_workout), params: { workout: { location: 'foobar' } }
        @user_workout.reload
        assert_equal 'foobar', @user_workout.location
        assert_redirected_to workouts_path
        # clean up
        @user_workout.update(location: 'crag x')
      end

      it 'should destroy workout' do
        assert_difference('Workout.count', -1) do
          delete workout_path(@user_workout)
        end
        assert_redirected_to workouts_path
      end
    end

    it 'should show the new workout form' do
      get new_workout_path, xhr: true
      assert_response :success
    end

    it 'should create workout' do
      assert_difference('Workout.count') do
        post workouts_path, xhr: true, params: { workout: { person: @user, location: 'elk lake', duration: 25, workout_on: Date.today } }
      end
      assert_redirected_to workouts_path
    end

  end
end
