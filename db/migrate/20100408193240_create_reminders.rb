class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.text :description
      t.boolean :done
      t.integer :priority
      t.integer :reminder_type
      t.integer :frequency
      t.date :repeat_until
      t.date :due_on
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reminders
  end
end
