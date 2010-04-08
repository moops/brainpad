class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.string :url
      t.string :price_url
      t.string :description
      t.integer :account_type
      t.float :units
      t.float :price
      t.boolean :active
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
