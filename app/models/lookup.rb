class Lookup
  include Mongoid::Document

  field :cat, as: :category, type: Integer
  field :code
  field :dsc, as: :description

  has_one :person


  has_one :workout, as: :workout_type

  attr_accessible :_id, :category, :code, :description

end
