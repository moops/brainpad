class Lookup
  include Mongoid::Document
  
  field :category, :type => Integer
  field :code
  field :description
  
  #embedded_in :workout, :inverse_of => :workout_type
  #embedded_in :workout, :inverse_of => :route 
  
  has_many :workouts, :inverse_of => :workout_type
  has_many :workouts, :inverse_of => :route
  
  def self.get_list(code)
    root = Lookup.find_by_code(code)
    Lookup.find_all_by_category(root.id)
  end
  
end
