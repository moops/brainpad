class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.string :name
      t.date :milestone_at
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :milestones
  end
end
