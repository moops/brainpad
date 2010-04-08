class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :url
      t.string :name
      t.string :tags
      t.string :comments
      t.integer :clicks
      t.datetime :last_clicked
      t.datetime :expires_on
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
