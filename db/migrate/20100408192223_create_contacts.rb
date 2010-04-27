class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :phone_home
      t.string :phone_work
      t.string :phone_cell
      t.string :address
      t.string :city
      t.string :tags
      t.text :comments
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
