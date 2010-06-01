class Payment < ActiveRecord::Base

  belongs_to :person
  belongs_to :account
  belongs_to :transfer_account, :class_name => 'Account', :foreign_key => 'transfer_from'

  attr_accessor :payment_type

  def apply_to_account
    account.units += (amount / account.price)
    account.save
    if transfer_account
      transfer_account.units -= (amount / transfer_account.price)
      transfer_account.save
    end
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
    freq_code = Lookup.find(frequency).code.to_i
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
    query = "select p.* from payments p, accounts a where p.account_id = a.id and a.active = 1 and a.person_id = ? and p.amount < 0 and payment_on > ?"
    Payment.find_by_sql([query,user.id,Date.today()- days])
  end

  def self.recent_transfers(user, days)
    query = "select p.* from payments p, accounts a where p.account_id = a.id and a.active = 1 and a.person_id = ? and p.transfer_from is not null and payment_on > ?"
    Payment.find_by_sql([query,user.id,Date.today()- days])
  end

  def self.recent_deposits(user, days)
    query = "select p.* from payments p, accounts a where p.account_id = a.id and a.active = 1 and a.person_id = ? and p.transfer_from is null and p.amount > 0 and payment_on > ?"
    Payment.find_by_sql([query,user.id,Date.today()- days])
  end
  
  def self.find_recent(user, days)
    all = recent_expenses(user, days)
    all += recent_transfers(user, days)
    all += recent_deposits(user, days)
    all.sort!{|x,y| y.payment_on <=> x.payment_on }
  end
  
  def self.find_upcoming(user)
    query = "select p.* from payments p where p.frequency is not null and p.person_id = ?"
    repeating = Payment.find_by_sql([query,user.id])
    logger.info("repeating: #{repeating.inspect}")
    for p in repeating
      p.build_repeat
    end
    upcoming = Payment.find_by_sql([query,user.id])
    logger.info("upcoming: #{upcoming.inspect}")
    upcoming.sort! {|x,y| x.payment_on <=> y.payment_on }
  end

  def self.days_with_expenses?(user,days)
    ActiveRecord::Base.connection.select_one("SELECT count( distinct payment_on) as s FROM payments WHERE account_id in (select account_id from accounts where person_id = #{user.id}) and amount < 0 and payment_on between '#{Date.today - days}' and '#{Date.today+(1)}'")['s'].to_i
  end

  def self.user_tags(user)
    tags = []
    payments = Payment.find(:all, :conditions => "account_id in(select id from accounts where person_id = #{user.id})")
    payments.each { |p|
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
  
end
