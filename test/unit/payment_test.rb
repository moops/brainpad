require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  let(:adam) { Person.find_by(username: 'adam') }
  let(:chequing) { adam.accounts.find_by(name: 'chequing') }
  let(:savings) { adam.accounts.find_by(name: 'savings') }
  let(:visa) { adam.accounts.find_by(name: 'visa') }
  let(:deposit) { Payment.new(person: adam, to_account: chequing, amount: 200, payment_on: Date.today) }
  let(:expense) { Payment.new(person: adam, from_account: chequing, amount: 25, payment_on: Date.today) }

  it 'finds the opening balances' do
    assert_equal 200, savings.balance, 'opening balance should be 200'
    assert_equal -200, visa.balance, 'opening balance should be -200'
    assert_equal 1000, chequing.balance, 'opening balance should be 1000'
  end

  it 'fails to save without required fields' do
    payment = Payment.new
    refute payment.save, 'saved without person'
    payment.person = adam

    refute payment.save, 'saved without account'
    payment.from_account = chequing

    refute payment.save, 'saved without amount'
    payment.amount = 25

    refute payment.save, 'saved without payment date'
    payment.payment_on = Date.today

    assert payment.save, 'save with all required fields'
  end

  it 'finds the right type' do
    refute deposit.expense?
    assert deposit.deposit?
    deposit.from_account = savings # now it should be a transfer
    refute deposit.deposit?
    assert deposit.transfer?
  end

  it 'applies expense to account balance' do
    opening_balance = chequing.balance
    expense = Payment.new(person: adam, from_account: chequing, amount: 100, payment_on: Date.today)
    expense.apply
    assert_equal opening_balance - 100, chequing.balance, 'expense not applied to chequing account'
    # reverse it
    expense.apply(true)
    assert_equal opening_balance, chequing.balance, 'expense not reversed from chequing account'
  end

  it 'applies deposit to account balance' do
    opening_balance = chequing.balance
    deposit = Payment.new(person: adam, to_account: chequing, amount: 100, payment_on: Date.today)
    deposit.apply
    assert_equal opening_balance + 100, chequing.balance, 'deposit not applied to chequing account'
    # reverse it
    deposit.apply(true)
    assert_equal opening_balance, chequing.balance, 'deposit not reversed from chequing account'
  end

  it 'applies transfer to account balances' do
    opening_chequing_balance = chequing.balance
    opening_savings_balance = savings.balance
    transfer = Payment.new(person: adam, from_account: chequing, to_account: savings, amount: 100, payment_on: Date.today)
    transfer.apply
    assert_equal opening_chequing_balance - 100, chequing.balance, 'transfer not applied to chequing account'
    assert_equal opening_savings_balance + 100, savings.balance, 'transfer not applied to savings account'
    # reverse it
    transfer.apply(true)
    assert_equal opening_chequing_balance, chequing.balance, 'transfer not reversed from chequing account'
    assert_equal opening_savings_balance, savings.balance, 'transfer not reversed from savings account'
  end

  it 'updates amount and adjusts account' do
    opening_balance = chequing.balance
    # expense
    expense = Payment.new(person: adam, from_account: chequing, amount: 100, payment_on: Date.today)
    expense.update_amount_and_adjust_account(50)
    # the $100 expense was already in the chequing balance ($1000), now we're changing it to a $50 expense, the balance should increase by $50
    assert_equal opening_balance + 50, chequing.balance, 'not applied to account balance'
    assert_equal 50, expense.amount, 'payment amount not updated'

    # deposit
    opening_balance = chequing.balance
    deposit = Payment.new(person: adam, to_account: chequing, amount: 100, payment_on: Date.today)
    deposit.update_amount_and_adjust_account(50)
    # the $100 deposit was already in the chequing balance ($1000), now we're changing it to a $50 deposit, the balance should decrease by $50
    assert_equal opening_balance - 50, chequing.balance, 'not applied to account balance'
    assert_equal 50, deposit.amount, 'payment amount not updated'
  end
end
