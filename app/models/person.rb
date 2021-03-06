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

  with_options dependent: :destroy do |person|
    person.has_many :accounts
    person.has_many :payments
    person.has_many :connections
    person.has_many :contacts
    person.has_many :journals
    person.has_many :links
    person.has_many :reminders
    person.has_many :workouts
    person.has_many :milestones
  end

  embeds_many :tag_lists

  has_secure_password
  validates :username, presence: true, uniqueness: true

  ROLES = %w[admin user].freeze

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

  def admin?
    role?(:admin)
  end

  def age_in_days
    Time.zone.today - born_on
  end

  def age_in_years
    y = Time.zone.today.year - born_on.year
    y -= 1 if Time.zone.today.yday < born_on.yday
    y
  end

  def days_left
    # based on 84 year life expectancy
    (born_on >> (84 * 12)) - Time.zone.today
  end

  def active_accounts
    a = accounts.select(&:active)
    a.sort_by(&:name)
  end

  def tag(type, tags)
    return if tags.blank?
    l = tag_lists.find_by(type: type) || tag_lists.build(type: type)
    l.tags ||= []
    l.tags = l.tags | tags.split(' ')
    l.save
  end

  def tags_for(type)
    t = (tag_lists.find_by(type: type) || tag_lists.new).tags
    t ? t.sort : []
  end
end
