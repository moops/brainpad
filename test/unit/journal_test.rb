require 'test_helper'

class JournalTest < ActiveSupport::TestCase
  let(:adam) { Person.find_by(username: 'adam') }

  it 'fails to save without required fields' do
    journal = Journal.new
    refute journal.save, 'saved without person'
    journal.person = adam

    refute journal.save, 'saved without entry'
    journal.entry = 'test entry'

    refute journal.save, 'saved without entry date'
    journal.entry_on = Date.today

    assert journal.save, 'save with all required fields'
  end
end
