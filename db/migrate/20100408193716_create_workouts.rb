class CreateWorkouts < ActiveRecord::Migration
  def self.up
    create_table :workouts do |t|
      t.string :location
      t.string :race
      t.string :route
      t.text :description
      t.integer :duration
      t.integer :intensity
      t.integer :weight
      t.float :distance
      t.integer :workout_type
      t.date :workout_on
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :workouts
  end
end
