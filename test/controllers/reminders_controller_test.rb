require 'test_helper'

class RemindersControllerTest < ActionDispatch::IntegrationTest
  let(:adam) { Person.find_by(username: 'adam') }
  let(:adam_entry) { adam.reminders.first }
  let(:quinn) { Person.find_by(username: 'quinn') }
  let(:quinn_entry) { quinn.reminders.first }

  describe 'unauthenticated user test' do
    it 'should not allow index access while unauthenticated' do
      get reminders_path
      assert_redirected_to root_url
    end
  end

  describe 'authenticated' do

    before do
      login quinn
    end

    it 'should get index' do
      get reminders_path
      assert_response :success
      assert_not_nil assigns(:reminders)
      assert_select 'span.list-title', 'reminders'
    end

    it 'should not show reminders belonging to others' do
      get reminder_path(adam_entry)
      assert_redirected_to root_url
    end

    it 'should show reminders belonging current user' do
      get reminder_path(quinn_entry), xhr: true
      assert_response :success
      assert_select 'h3', /^reminder details.*/
    end

    it 'should create reminder' do
      assert_difference('Reminder.count') do
        post reminders_path, xhr: true, params: { reminder: { person: quinn, description: 'test entry', due_at: Time.now + 18.hours } }
      end
      assert_redirected_to reminders_path
    end

    it 'should get edit' do
      get edit_reminder_path(quinn_entry), xhr: true
      assert_response :success
      assert_select 'h3', /^update reminder.*/
    end

    it 'should update reminder' do
      put reminder_path(quinn_entry), xhr: true, params: { reminder: { description: 'foobar' } }
      quinn_entry.reload
      assert_equal 'foobar', quinn_entry.description
      assert_redirected_to reminders_path
      # clean up
      quinn_entry.update(description: 'climbing competition')
    end

    it 'should destroy reminder' do
      destroyable = quinn.reminders.create(description: 'destroyable reminder', due_at: Time.now + 2.hours)
      assert_difference('Reminder.count', -1) do
        delete reminder_path(destroyable)
      end
      assert_redirected_to reminders_path
    end
  end
end

