class Session
  include Mongoid::Document
  
  field :login_at, :type => Date
  field :logout_at, :type => Date
  field :count, :type => Integer
  
  attr_accessible :user_id, :login_at, :logout_at, :count
  
end
