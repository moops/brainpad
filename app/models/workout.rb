class Workout < ActiveRecord::Base

  belongs_to :person
  
  validates_presence_of :person, :location, :duration, :workout_on
  
end
