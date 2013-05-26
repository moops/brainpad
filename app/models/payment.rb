class Payment
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :dsc, as: :description
  field :tg, as: :tags
  field :am, as: :amount, type: Float
  field :p_on, as: :payment_on, type: Date
  field :un, as: :until, type: Date

  belongs_to :person
  belongs_to :from_account, class_name: 'Account'
  belongs_to :to_account, class_name: 'Account'
  belongs_to :frequency, class_name: "Lookup"

  validates_presence_of :amount, :payment_on

  attr_accessible :amount, :description, :tags, :payment_on, :until, :from_account, :to_account, :frequency

  attr_accessor :payment_type

  def account_name
    return "#{from_account.name} -> #{to_account.name}" if from_account and to_account
    return from_account.name if from_account
    return to_account.name if to_account
  end

  def type
    return 'transfer' if from_account and to_account
    return 'deposit' if to_account
    return 'expense' if from_account
  end

  def apply(reverse= false)
    amt = amount
    amt *= -1 if reverse
    if from_account
      from_account.units -= (amt / from_account.price)
      from_account.save
    end
    if to_account
      to_account.units += (amt / to_account.price)
      to_account.save
    end
  end

  def update_amount_and_adjust_account(new_amount)
    # reverse it
    apply(true)
    # apply new amount
    self.amount = new_amount
    self.save
    # apply it
    apply
  end

  def build_repeat
    if frequency and next_due <= Date.today
      # repeating and due
      new_payment = self.clone
      new_payment.payment_on = next_due
      new_payment.save
      new_payment.apply
      # recursion
      new_payment.build_repeat
      self.frequency = nil
      self.until = nil
      self.save
    end
  end

  def next_due
    freq_code = frequency.code.to_i
    if (freq_code < 15) # daily, weekly or biweekly
      due = payment_on + freq_code
    elsif (freq_code == 15) # twice monthly
      last_day_of_month = Date.civil(payment_on.year, payment_on.month, -1).day
      if payment_on.day == last_day_of_month
        due = payment_on>>(1)
        due = Date.civil(due.year, due.month, 15)
      else
        day = payment_on.day < 15 ? 15 : -1
        due = Date.civil(payment_on.year, payment_on.month, day)
      end
    elsif (freq_code == 30) # monthly
      due = payment_on>>(1)
    elsif (freq_code == 365)
      due = payment_on>>(12)
    end
    due
  end

  def self.recent_expenses(user, days)
    user.payments.ne(from_account: nil).gt(payment_on: Date.today - days)
  end

  def self.recent_transfers(user, days)
    user.payments.ne(from_account: nil).ne(to_account: nil).gt(payment_on: Date.today - days)
  end

  def self.recent_deposits(user, days)
    user.payments.ne(to_account: nil).gt(payment_on: Date.today - days)
  end

  def self.find_recent(user, days)
    all = recent_expenses(user, days)
    all += recent_transfers(user, days)
    all += recent_deposits(user, days)
    all.sort!{|x,y| y.payment_on <=> x.payment_on }
  end

  def self.upcoming(user)
    user.payments.ne(frequency: nil).each do |p|
      p.build_repeat
    end
    user.payments.ne(frequency: nil).desc(:payment_on)
  end

  def self.days_with_expenses?(user,days)
    user.payments.ne(from_account: nil).between(payment_on: Date.today - days..Date.today + 1).distinct(:payment_on).count
  end

  def self.expenses_by_tag(user,days)
    result_hash = Hash.new
    for exp in recent_expenses(user,days)
      unless exp.tags.nil?
        for tag in exp.tags.split
          result_hash[tag] ||= 0
          result_hash[tag] = result_hash[tag] + exp.amount.abs
        end
      end
    end
    result_array = result_hash.sort{|a,b| b[1]<=>a[1]}
    result_array.first(8)
  end

  def self.summary(user,days=31)
    deposits = Payment.recent_deposits(user,days)
    total = 0
    balance = 0
    income = 0

    deposits.each do |dep|
      income += dep.amount
    end
    expenses = Payment.recent_expenses(user,days)
    expenses.each do |exp|
      total += exp.amount.abs
    end
    user.active_accounts.each do |account|
      balance += account.balance
    end
    {
      total: total,
      net_change: income - total,
      per_day: total/days,
      buy_nothing_days: days - Payment.days_with_expenses?(user,days),
      balance: balance
    }
  end
end