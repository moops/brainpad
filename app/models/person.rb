class Person
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include ActiveModel::SecurePassword

  field :un, as: :username
  field :b_on, as: :born_on, type: Date
  field :em, as: :email
  field :b_url, as: :banking_url
  field :m_c, as: :map_center
  field :auth, as: :authority, type: Integer
  field :pwd, as: :password_digest
  field :ph, as: :phone

  with_options dependent: :destroy do |assoc|
    assoc.has_many :accounts
    assoc.has_many :payments
    assoc.has_many :connections
    assoc.has_many :contacts
    assoc.has_many :journals
    assoc.has_many :links
    assoc.has_many :reminders
    assoc.has_many :workouts
    assoc.has_many :milestones
  end

  embeds_many :tag_lists

  has_secure_password
  validates_presence_of :username
  validates_uniqueness_of :username
  attr_accessible :username, :password, :password_confirmation, :born_on, :authority, :email, :banking_url, :map_center, :phone

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

  def tag(type, tags)
    unless tags.blank?
      l = tag_lists.where(type: type).first || self.tag_lists.build(type: type)
      l.tags ||= []
      l.tags = l.tags | tags.split(' ')
      l.save
    end
  end
  
  def tags_for(type)
    (tag_lists.where(type: type).first || tag_lists.new).tags
  end

end
