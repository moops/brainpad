class Person
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :username
  field :born_on, type: Date
  field :mail_url
  field :banking_url
  field :map_center
  field :authority, type: Integer
  field :password_digest

  has_many :accounts
  has_many :connections
  has_many :contacts
  has_many :journals
  has_many :links
  has_many :reminders
  has_many :workouts
  has_many :milestones
  #has_many :payments, :through => :accounts

  has_secure_password
  validates_presence_of :username
  validates_uniqueness_of :username
  attr_accessible :username, :password, :password_confirmation, :born_on, :authority, :mail_url, :map_center

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

  def age_in_days
    Date.today - born_on
  end

  def age_in_years
    y = Date.today.year - born_on.year
    y -= 1 if (Date.today.yday < born_on.yday)
    y
  end

  def days_left
    #based on 84 year life expectancy 
    (born_on>>(84*12)) - Date.today
  end

  def active_accounts
    a = accounts.reject { |a| not a.active }
    a.sort_by{|a| a.name }
  end

end
