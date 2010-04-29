class CreateAccountPrices < ActiveRecord::Migration
  def self.up
    create_table :account_prices do |t|
      t.integer :account_id
      t.float :price
      t.date :price_on

      t.timestamps
    end
  end

  def self.down
    drop_table :account_prices
  end
end
