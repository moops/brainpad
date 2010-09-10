class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :user_name
      t.string :mail_url
      t.string :banking_url
      t.string :map_center

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
