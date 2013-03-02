class AccountPrice
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :price, type: Float
  field :price_on, type: Date

  embedded_in :account

end
