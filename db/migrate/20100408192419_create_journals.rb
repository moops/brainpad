class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journals do |t|
      t.text :entry
      t.date :entry_on
      t.integer :journal_type
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :journals
  end
end
