require 'test_helper'

class ReminderTest < ActiveSupport::TestCase
  let(:adam) { Person.find_by(username: 'adam') }

  it 'fails to save without required fields' do
    a = Reminder.new
    refute a.save, 'saved without person'
    a.person = adam

    refute a.save, 'saved without description'
    a.description = 'get something done'

    refute a.save, 'saved without due date'
    a.due_at = Date.today + 1

    assert a.save, 'save with all required fields'
  end
end
