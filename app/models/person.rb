class Person
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :user_name
  field :mail_url
  field :banking_url
  field :map_center
  field :authority, :type => Integer
  field :password_digest

  has_many :accounts
  has_many :connections
  has_many :contacts
  has_many :journals
  has_many :links
  has_many :reminders
  has_many :workouts
  #has_many :payments, :through => :accounts

  has_secure_password
  validates_presence_of :user_name
  validates_uniqueness_of :user_name
  attr_accessible :user_name, :password, :password_confirmation

  ROLES = %w[admin user]

  def roles=(roles)
    self.authority = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((authority || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  def role_symbols
    roles.map(&:to_sym)
  end

  def age_in_days?
    Date.today - auth_profile.born_on
  end

  def age_in_years?
    y = Date.today.year - auth_profile.born_on.year
    y -= 1 if (Date.today.yday < auth_profile.born_on.yday)
    y
  end

  def days_left?
    #based on 84 year life expectancy 
    (auth_profile.born_on>>(84*12)) - Date.today
  end

  def active_accounts
    a = accounts.reject { |a| not a.active }
    a.sort_by{|a| a.name }
  end

  #def payments
  #  p = Array.new
  #  for a in active_accounts
  #    p += a.payments
  #  end
  #  p
  #end

  def name?
    auth_profile.name ? auth_profile.name : user_name
  end
end
