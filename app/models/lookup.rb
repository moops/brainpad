class Lookup < ActiveRecord::Base
  
  def self.get_list(code)
    root = Lookup.find_by_code(code)
    Lookup.find_all_by_category(root.id)
  end
  
end
