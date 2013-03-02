class Account
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :nm, as: :name
  field :url
  field :p_url, as: :price_url
  field :dsc, as: :description
  field :un, as: :units, :type => Float
  field :pr, as: :price, :type => Float
  field :act, as: :active, :type => Boolean

  belongs_to :person
  # embeds_many :prices, class_name: 'account_prices'
  embeds_many :account_prices, store_as: 'prices'

  validates_presence_of :name, :units, :price
  
  attr_accessible :person, :name, :url, :price_url, :description, :units, :price, :active
  
  scope :active, where(active: true)

  def balance
    units * price
  end
end
