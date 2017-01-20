require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  let(:adam) { Person.find_by(username: 'adam') }

  it 'fails to save without required username' do
    a = Person.new
    refute a.save, 'saved without username'
  end

  it 'saves with required username' do
    b = build(:person)
    assert b.save, "save with all required fields #{b.inspect}"
  end

  it 'requires unique username' do
    a = build(:person, username: 'test')
    b = build(:person, username: 'test')
    assert a.save, 'username is unique'
    refute b.save, 'username not unique'
  end
end
