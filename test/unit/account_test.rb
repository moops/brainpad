require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  let(:adam) { Person.find_by(username: 'adam') }

  it 'fails to save without required fields' do
    a = Account.new
    refute a.save, 'saved without person'
    a.person = adam

    refute a.save, 'saved without name'
    a.name = 'savings'

    refute a.save, 'saved without units'
    a.units = 200

    refute a.save, 'saved without price'
    a.price = 1

    assert a.save, 'save with all required fields'
  end

  test 'balance' do
    a = Account.new(person: adam, name: 'test account', units: 25, price: 2)
    assert_equal 50, a.balance
  end
end
