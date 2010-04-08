class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string :description
      t.string :tags
      t.float :amount
      t.date :payment_on
      t.integer :account_id
      t.integer :transfer_from
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
