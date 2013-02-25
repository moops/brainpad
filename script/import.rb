require 'pg'

puts 'import.rb is running'

conn = PG.connect( host: 'localhost', port: '5432', dbname: 'brainpad_production', user: 'postgres', password: '' ) 

# lookups
count = 0
conn.exec( "SELECT * FROM lookups" ) do |result| 
  result.each do |row|
    l = Lookup.create!(
      category: row['category'],
      code: row['code'], 
      description: row['description'])
    count += 1
    # puts l.inspect
  end
end
puts "inserted #{count} lookups..."

# people
count = 0
conn.exec( "SELECT * FROM people" ) do |result| 
  result.each do |row|
    p = Person.create!(
      _id: row['id'],
      username: row['user_name'], 
      born_on: row['born_on'], 
      mail_url: row['mail_url'], 
      banking_url: row['banking_url'], 
      map_center: row['map_center'], 
      authority: row['authority'], 
      password: "#{row['user_name']}_pass", 
      password_confirmation: "#{row['user_name']}_pass")
    count += 1
    # puts p.inspect
  end
end
puts "inserted #{count} people..."

Person.all.each do |person|

  # accounts
  count = 0
  conn.exec( "SELECT * FROM accounts WHERE person_id = #{person.id}" ) do |result| 
    result.each do |row|
      a = Account.new(
        _id: row['id'],
        person: person,
        name: row['name'], 
        url: row['url'], 
        price_url: row['price_url'], 
        description: row['description'], 
        units: row['units'], 
        price: row['price'], 
        active: row['active'])
      a.account_prices = []
      conn.exec( "SELECT * FROM account_prices p WHERE p.account_id = #{row['id']}" ) do |prices|
        prices.each do |price|
          a.account_prices << AccountPrice.new(price: price['price'], price_on: price['price_on'])
        end
      end
      a.save!
      count += 1
      # puts a.inspect
    end
  end
  puts "inserted #{count} accounts for #{person.username}"

  # connections
  count = 0
  conn.exec( "SELECT * FROM connections WHERE person_id = #{person.id}" ) do |result|
    result.each do |row|
      c = Connection.create!(
        person: person,
        name: row['name'], 
        username: row['username'], 
        password: row['password'], 
        url: row['url'], 
        description: row['description'], 
        tags: row['tags'])
      count += 1
      # puts c.inspect
    end
  end
  puts "inserted #{count} connections for #{person.username}"

  # contacts
  count = 0
  conn.exec( "SELECT * FROM contacts WHERE person_id = #{person.id}" ) do |result| 
    result.each do |row|
      c = Contact.create!(
        person: person,
        name: row['name'], 
        email: row['email'], 
        phone_home: row['phone_home'], 
        phone_work: row['phone_work'], 
        phone_cell: row['phone_cell'], 
        address: row['address'],  
        city: row['city'], 
        tags: row['tags'], 
        comments: row['comments'])
      count += 1
      # puts c.inspect
    end
  end
  puts "inserted #{count} contacts for #{person.username}"

  # journals
  count = 0
  conn.exec( "SELECT * FROM journals WHERE person_id = #{person.id}" ) do |result| 
    result.each do |row|
      j = Journal.create!(
        person: person,
        entry: row['entry'], 
        entry_on: row['entry_on'])
      count += 1
      # puts j.inspect
    end
  end
  puts "inserted #{count} journals for #{person.username}"

  # links
  count = 0
  conn.exec( "SELECT * FROM links WHERE person_id = #{person.id}" ) do |result| 
    result.each do |row|
      l = Link.create!(
        person: person,
        url: row['url'], 
        name: row['name'], 
        tags: row['tags'], 
        comments: row['comments'], 
        clicks: row['clicks'], 
        last_clicked_on: row['last_clicked_on'],  
        expires_on: row['expires_on'])
      count += 1
      # puts l.inspect
    end
  end
  puts "inserted #{count} links for #{person.username}"

  # lookups
  # handled by seeds.rb

  # milestones
  # don't need to import

  # payments
  count = 0
  conn.exec( "SELECT * FROM payments WHERE person_id = #{person.id}" ) do |result| 
    result.each do |row|
      p = Payment.new(
        person: person,
        description: row['description'], 
        tags: row['tags'], 
        payment_on: row['payment_on'], 
        until: row['until'])
      amount = row['amount'].to_f.round(2)
      if row['transfer_from'].blank?
        if amount.to_f < 0
          # expense
          p.from_account = Account.find(row['account_id'])
          amount = amount.abs
        else 
          # deposit
          p.to_account = Account.find(row['account_id'])
        end
      else 
        # transfer
        p.from_account = Account.find(row['transfer_from'])
        p.to_account = Account.find(row['account_id'])
      end
      p.amount = amount
      p.save!
      count += 1
      # puts p.inspect
    end
  end
  puts "inserted #{count} payments for #{person.username}"

  # reminders
  count = 0
  conn.exec( "SELECT * FROM reminders WHERE person_id = #{person.id}" ) do |result| 
    result.each do |row|
      r = Reminder.create!(
        person: person,
        description: row['description'], 
        tags: row['tags'], 
        done: row['done'], 
        repeat_until: row['repeat_until'], 
        due_on: row['due_on'])
      count += 1
      # puts r.inspect
    end
  end
  puts "inserted #{count} reminders for #{person.username}"

  # workouts
  count = 0
  conn.exec( "SELECT * FROM workouts WHERE person_id = #{person.id}" ) do |result| 
    result.each do |row|
      w = Workout.create!(
        person: person,
        location: row['location'], 
        race: row['race'], 
        description: row['description'], 
        duration: row['duration'], 
        intensity: row['intensity'], 
        weight: row['weight'], 
        distance: row['distance'], 
        workout_on: row['workout_on'])
      count += 1
      # puts w.inspect
    end
  end
  puts "inserted #{count} workouts for #{person.username}"
  
end



