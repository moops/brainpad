class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :url
  field :price_url
  field :description
  field :units, :type => Float
  field :price, :type => Float
  field :active, :type => Boolean

  embedded_in :person

  validates_presence_of :name, :units, :price

  def balance
    units * price
  end
end
