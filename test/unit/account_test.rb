require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  test "balance" do
    a = Account.new(:person => people(:adam), :name => 'test account', :units => 25, :price => 2)
    assert 50 == a.balance?
  end
end
