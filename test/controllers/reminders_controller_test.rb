require 'test_helper'

class RemindersControllerTest < ActionDispatch::IntegrationTest

  describe 'unauthenticated' do

    it 'should not allow index access' do
      get reminders_path
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

    it 'should not show reminders belonging to others' do
      # create a reminder belonging to a new user
      another_reminder = create(:reminder)
      get reminder_path(another_reminder)
      assert_redirected_to root_url
      # clean up the new reminder and person
      another_reminder.person.destroy
    end

    describe 'with a reminder' do

      before do
        @user_reminder = create(:reminder, person: @user)
      end

      after do
        @user_reminder.destroy if @user_reminder
      end

      it 'should get index' do
        get reminders_path
        assert_response :success
        assert_not_nil assigns(:reminders)
        assert_select 'span.list-title', 'reminders'
      end

      it 'should show reminders belonging current user' do
        get reminder_path(@user_reminder), xhr: true
        assert_response :success
        assert_select 'h5', /^reminder details.*/
      end

      it 'should get edit' do
        get edit_reminder_path(@user_reminder), xhr: true
        assert_response :success
        assert_select 'h5', /^update reminder.*/
      end

      it 'should update reminder' do
        put reminder_path(@user_reminder), xhr: true, params: { reminder: { description: 'foobar' } }
        @user_reminder.reload
        assert_equal 'foobar', @user_reminder.description
        assert_redirected_to reminders_path
      end

      it 'should destroy reminder' do
        assert_difference('Reminder.count', -1) do
          delete reminder_path(@user_reminder)
        end
        assert_redirected_to reminders_path
      end
    end

    it 'should show the new connection form' do
      get new_connection_path, xhr: true
      assert_response :success
    end

    it 'should create reminder' do
      assert_difference('Reminder.count') do
        post reminders_path, xhr: true, params: { reminder: { person: @user, description: 'test entry', due_at: Time.now + 18.hours } }
      end
      assert_redirected_to reminders_path
    end
  end
end

