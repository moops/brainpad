class Lookup
  include Mongoid::Document

  field :cat, as: :category, type: Integer
  field :code
  field :dsc, as: :description

  has_one :person
end
