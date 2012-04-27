class AccountPrice
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :account_id, :type => Integer
  field :price, :type => Float
  field :price_on, :type => Date

end
