class Payment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :description
  field :tags
  field :amount, :type => Float
  field :payment_on, :type => Date
  field :until, :type => Date

  belongs_to :person
  belongs_to :from_account, :class_name => 'Account'
  belongs_to :to_account, :class_name => 'Account'
  belongs_to :frequency, class_name: "Lookup"
  
  validates_presence_of :amount, :payment_on

  attr_accessor :payment_type
  
  def description_condensed
    description.length > 25 ? "#{description[0,25]}..." : description if description
  end
  
  def account_name
    return "#{from_account.name} -> #{to_account.name}" if from_account and to_account
    return from_account.name if from_account
    return to_account.name if to_account
  end

  def payment_type?
    if transfer_account
      return 'transfer'
    elsif amount and amount > 0
      return 'deposit'
    elsif amount and amount <= 0
      return 'expense'
    end
  end
  
  def apply_to_account(reverse= false)
    amt = reverse ? -amount : amount
    account.units += (amt / account.price)
    account.save
    if transfer_account
      transfer_account.units -= (amt / transfer_account.price)
      transfer_account.save
    end
  end
  
  def update_amount_and_adjust_account(new_amount)
    # reverse it
    apply_to_account(true)
    # apply new amount
    self.amount = new_amount
    self.save
    # apply it
    apply_to_account
  end
  
  def build_repeat
    if frequency and next_due <= Date.today
      # repeating and due
      new_payment = self.clone
      new_payment.payment_on = next_due
      new_payment.save
      new_payment.apply_to_account
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

  def self.user_tags(user)
    tags = []
    user.payments.each { |p|
      if p.tags 
        p.tags.split.each { |t|
          tags.push(t.strip)
        }
      end
    }
    tags.push('')
    tags.uniq!
    tags.sort!
    tags
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
      balance += account.balance?
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