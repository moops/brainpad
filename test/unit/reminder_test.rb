require 'test_helper'

class ReminderTest < ActiveSupport::TestCase

  test "save without required fields" do
    a = Reminder.new
    assert !a.save, 'saved without person'
    a.person= people(:adam)

    assert !a.save, 'saved without description'
    a.description= 'get something done'

    assert !a.save, 'saved without due date'
    a.due_at= Date.today + 1

    assert a.save, 'save with all required fields'
  end

end
