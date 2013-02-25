class Lookup
  include Mongoid::Document
  
  field :cat, as: :category, :type => Integer
  field :code
  field :dsc, as: :description
  
  def self.get_list(code)
    root = Lookup.find_by_code(code)
    Lookup.find_all_by_category(root.id)
  end
  
end
