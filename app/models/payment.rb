class Payment < ActiveRecord::Base

  belongs_to :person
  belongs_to :account
  belongs_to :transfer_account, :class_name => 'Account', :foreign_key => 'transfer_from'
  belongs_to :frequency, :class_name => 'Lookup', :foreign_key => 'repeat'

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

  def update_and_adjust_account(attributes)
    old_amount = amount
    self.attributes=(attributes)
    self.amount = -self.amount if self.payment_type.eql?('expense')
    account.adjust!(old_amount,amount)
    return self.save
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

  def self.find_upcoming(user)
    upcoming = Array.new
    for p in find_and_update_scheduled(user)
      next_on = p.schedule.due?(p.payment_on)
      next_payment = p.clone
      next_payment.payment_on = next_on
      upcoming<<(next_payment)
    end
    upcoming.sort! {|x,y| x.payment_on <=> y.payment_on }
  end

  def self.find_recent(user, days)
    all = recent_expenses(user, days)
    all += recent_transfers(user, days)
    all += recent_deposits(user, days)
    all.sort!{|x,y| y.payment_on <=> x.payment_on }
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
    logger.info("result_array: #{result_array.inspect}")
    result_array.first(8)
  end
  
  
  
    def self.find_and_update_scheduled(user)
      query = "select p.* from payments p where p.repeat is not null and p.person_id = ?"
      repeating = Payment.find_by_sql([query,user.id])
      for p in repeating
        if p.account.active?
        
          next_on = p.due?
          while next_on <= Date.today
            
            new_payment = p.clone
            new_payment.payment_on = next_on
            new_payment.save
            new_payment.apply_to_account # only if not in the future

            next_on = new_payment.due?
          end
          
        end
      end
      most_recents = Payment.find_by_sql([query,user.id]) if created_something
      most_recents
    end

    def due?
      frequency = Lookup.find(repeat).code.to_i
      if (frequency < 15) # daily, weekly or biweekly
        due = payment_on + f
      elsif (frequency == 15) # twice monthly
        due = payment_on.day < 16 ? payment_on + (15 - payment_on.day) : Date.civil(payment_on.year, payment_on.month, -1)
      elsif (frequency == 30) # monthly
        due = payment_on>>(1)
      elsif (frequency == 365)
        due = payment_on>>(12)
      end
      due
    end
  
end
