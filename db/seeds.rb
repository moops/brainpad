# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Lookup.create({ :id => 1, :category => 1, :code => 'root', :description => 'root'})
Lookup.create({ :id => 2, :category => 1, :code => 'reminder_type', :description => 'reminder_type'})
Lookup.create({ :id => 3, :category => 2, :code => 'home', :description => 'home'})
Lookup.create({ :id => 4, :category => 2, :code => 'race', :description => 'race'})
Lookup.create({ :id => 5, :category => 2, :code => 'kids', :description => 'kids'})
Lookup.create({ :id => 6, :category => 2, :code => 'other', :description => 'other'})

adam = Person.create({ :id => 1, :name => 'Adam Lawrence', :user_name => 'adam', :password => 'adam', :mail_url => 'http://mail.google.com/mail', :authority => 1, :birth_on => '1969-07-09'})
