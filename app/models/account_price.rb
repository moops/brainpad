class AccountPrice
  include Mongoid::Document
  
  field :account_id, type: Integer
  field :price, type: Float
  field :price_on, type: Date
  field :created_at, type: DateTime
  field :updated_at, type: DateTime
end
