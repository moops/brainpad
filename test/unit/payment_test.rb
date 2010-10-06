require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  
  test "save without required fields" do
    a = Payment.new
    assert !a.save, 'saved without person'
    a.person= people(:adam)

    assert !a.save, 'saved without account'
    a.account= accounts(:chequing)

    assert !a.save, 'saved without amount'
    a.amount= 25
    
    assert !a.save, 'saved without payment date'
    a.payment_on= Date.today

    assert a.save, 'save with all required fields'
  end
  
  test "payment type" do
    a = Payment.new(:person => people(:adam), :account => accounts(:chequing), :amount => 25, :payment_on => Date.today)
    assert 'deposit'.eql?(a.payment_type?), 'type is not deposit'
    a.amount *= -1
    assert 'expense'.eql?(a.payment_type?), 'type is not expense'
    a.transfer_account= accounts(:visa)
    assert 'transfer'.eql?(a.payment_type?), 'type is not transfer'
  end
  
  test "apply expense to account" do
    chq = accounts(:chequing)
    assert chq.balance? == 1500, 'starting chequing balance is not 1500, fixture issue?'
    a = Payment.new(:person => people(:adam), :account => accounts(:chequing), :amount => -100, :payment_on => Date.today)
    a.apply_to_account
    assert chq.balance? == 1400, 'expense not applied to chequing account'
    # reverse it
    a.apply_to_account(true)
    assert chq.balance? == 1500, 'expense not reversed from chequing account'
  end
  
  test "apply deposit to account" do
    chq = accounts(:chequing)
    assert chq.balance? == 1500, 'starting chequing balance is not 1500, fixture issue?'
    a = Payment.new(:person => people(:adam), :account => accounts(:chequing), :amount => 100, :payment_on => Date.today)
    a.apply_to_account
    assert chq.balance? == 1600, 'deposit not applied to chequing account'
    # reverse it
    a.apply_to_account(true)
    assert chq.balance? == 1500, 'deposit not reversed from chequing account'
  end
  
  test "apply transfer to account" do
    from = accounts(:chequing)
    to = accounts(:cash)
    assert from.balance? == 1500, 'starting chequing balance is not 1500, fixture issue?'
    assert to.balance? == 500, 'starting cash balance is not 500, fixture issue?'
    a = Payment.new(:person => people(:adam), :transfer_account => accounts(:chequing), :account => accounts(:cash), :amount => 100, :payment_on => Date.today)
    a.apply_to_account
    assert from.balance? == 1400, 'transfer not applied to chequing account'
    assert to.balance? == 600, 'transfer not applied to cash account'
    # reverse it
    a.apply_to_account(true) 
    assert from.balance? == 1500, 'transfer not reversed from chequing account'
    assert to.balance? == 500, 'transfer not reversed from cash account'
  end
  
  test "update amount and adjust account" do
    chq = accounts(:chequing)
    assert chq.balance? == 1500, 'starting chequing balance is not 1500, fixture issue?'
    #expense
    p = Payment.new(:person => people(:adam), :account => accounts(:chequing), :amount => -100, :payment_on => Date.today)
    p.update_amount_and_adjust_account(-50)
    #the $100 expense was already in the chequing balance ($1500), now we're changing it to a $50 expense, the balance should increase by $50
    assert chq.balance? == 1550, 'not applied to account balance'
    assert p.amount == -50, 'payment amount not updated'
    
    #deposit
    p = Payment.new(:person => people(:adam), :account => accounts(:chequing), :amount => 100, :payment_on => Date.today)
    p.update_amount_and_adjust_account(50)
    #the $100 deposit was already in the chequing balance ($1550), now we're changing it to a $50 deposit, the balance should decrease by $50
    assert chq.balance? == 1500, 'not applied to account balance'
    assert p.amount == 50, 'payment amount not updated'
  end
  
end
