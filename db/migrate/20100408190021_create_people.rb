class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :name
      t.string :user_name
      t.string :password
      t.string :mail_url
      t.string :banking_url
      t.string :map_center
      t.integer :authority
      t.date :born_on
      t.datetime :last_login_at

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
