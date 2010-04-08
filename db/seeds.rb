# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

adam = Person.create({ :id => 1, :name => 'Adam Lawrence', :user_name => 'adam', :password => 'adam', :mail_url => 'http://mail.google.com/mail', :authority => 1, :birth_on => '1969-07-09'})
