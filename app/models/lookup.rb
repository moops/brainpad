class Lookup
  include Mongoid::Document
  
  field :category, type: Integer
  field :code, type: String
  field :description, type: String
  
  def self.get_list(code)
    root = Lookup.find_by_code(code)
    Lookup.find_all_by_category(root.id)
  end
  
end
