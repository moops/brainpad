class Lookup
  include Mongoid::Document
  
  field :cat, as: :category, :type => Integer
  field :code
  field :dsc, as: :description
  
  attr_accessible :_id, :category, :code, :description

end
