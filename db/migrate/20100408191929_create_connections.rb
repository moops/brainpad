class CreateConnections < ActiveRecord::Migration
  def self.up
    create_table :connections do |t|
      t.string :name
      t.string :user_name
      t.string :password
      t.string :url
      t.text :description
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :connections
  end
end
