desc "build a demo user"

task :demo_user => :environment do
  
  demo = Person.where(username: 'demo').first
  demo.destroy if demo
  
  demo  = Person.create({ username: 'demo', password: 'demo', password_confirmation: 'demo', born_on: 20.years.ago, authority: '2', email: 'demo@raceweb.ca', map_center: '48.468141,-123.358612', phone: '+12508812818' })

  Link.create({ person_id: demo.id, url: 'http://www.nba.com', name: 'nba', tags: 'sports', comments: 'gets worse every year', clicks: 15, last_clicked_on: '2013-02-01', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.nhl.com', name: 'nhl', tags: 'sports', comments: 'boycotting', clicks: 5, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.imgur.com', name: 'imgur', tags: 'pictures', comments: 'pictures for everything', clicks: 5, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.reddit.com', name: 'reddit', tags: 'news', comments: 'careful if you have stuff to do', clicks: 22, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.cnn.com', name: 'cnn', tags: 'news', comments: 'ratings based news', clicks: 19, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.cbc.ca', name: 'cbc', tags: 'news', comments: 'canadian news', clicks: 33, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.cyclingnews.com', name: 'cycling news', tags: 'cycling news', comments: 'everything cycling', clicks: 18, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.imdb.com', name: 'nhl', tags: 'movies', comments: 'everything movies', clicks: 11, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.rottentomatoes.com', name: 'rotten tomatoes', tags: 'movies', comments: 'good ratings', clicks: 9, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://rubyonrails.org', name: 'rails', tags: 'dev rails', comments: 'web framework', clicks: 12, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://railscasts.com', name: 'railscasts', tags: 'dev rails', comments: 'video tutorials on everything', clicks: 24, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.w3schools.com', name: 'w3schools', tags: 'dev css', comments: 'simple reference', clicks: 2, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.codeschool.com', name: 'codeschool', tags: 'dev', comments: 'video tutorials', clicks: 3, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://twitter.github.com/bootstrap/index.html', name: 'bootstrap', tags: 'dev css', comments: 'twitter css framework', clicks: 15, last_clicked_on: '2013-02-10', expires_on: nil })
  Link.create({ person_id: demo.id, url: 'http://www.jquery.com', name: 'jquery', tags: 'dev javascript', comments: 'javascript framework', clicks: 5, last_clicked_on: '2013-02-10', expires_on: nil })
  
  Contact.create({ person_id: demo.id, name: 'kermit', email: 'kermit@raceweb.ca', phone_home: '250-347-9021', phone_work: '250-342-6416', address: '123 fake st', city: 'victoria', tags: 'frog friend', comments: 'why does he hang out with that pig?' })
  Contact.create({ person_id: demo.id, name: 'gonzo', email: 'gonzo@raceweb.ca', phone_home: '250-344-6584', phone_work: '250-344-6584', address: '123 sesame st', city: 'victoria', tags: 'family', comments: 'is that thing even a nose?' })
  Contact.create({ person_id: demo.id, name: 'fozzie', email: 'fozzie@raceweb,ca', phone_home: '250-658-4719', phone_work: '250-342-6416', address: '123 fake st', city: 'victoria', tags: 'family', comments: 'just smile and nod when he starts telling jokes' })
  Contact.create({ person_id: demo.id, name: 'floyd', email: 'floyd@raceweb,ca', phone_home: '250-658-4719', phone_work: '250-342-6416', address: '123 fake st', city: 'victoria', tags: 'friend band', comments: 'he hold that band together' })
  Contact.create({ person_id: demo.id, name: 'scooter', email: 'scooter@raceweb,ca', phone_home: '250-414-0106', phone_work: '250-342-6416', address: '123 fake st', city: 'victoria', tags: 'family', comments: 'good helper' })

  run   = Lookup.where(code: 'run').first
  bike  = Lookup.where(code: 'bike').first
  swim  = Lookup.where(code: 'swim').first
  other = Lookup.where(code: 'other').first
  w1 = Workout.create({ person_id: demo.id, location: 'thetis', duration: 60, distance: 10, intensity: 5, workout_type: run, workout_on: '2013-02-01', weight: 165, description: 'easy run around thetis' })
  w2 = Workout.create({ person_id: demo.id, location: 'elk lake', duration: 60, distance: 10, intensity: 5, workout_type: run, workout_on: '2013-02-02', weight: 168, description: 'easy run around elk lake' })
  w3 = Workout.create({ person_id: demo.id, location: 'goose', duration: 60, distance: 40, intensity: 5, workout_type: bike, workout_on: '2013-02-03', description: 'easy ride on the goose' })

  chequing = Account.create({ person_id: demo.id, name: 'chequing', price: 1, units: 1000, active: true })
  savings  = Account.create({ person_id: demo.id, name: 'savings', price: 1, units: 200, active: true })
  visa     = Account.create({ person_id: demo.id, name: 'visa', price: 1, units: -200, active: true })
  cash     = Account.create({ person_id: demo.id, name: 'cash', price: 1, units: 300, active: true })

  ch1 = Payment.create({ person_id: demo.id, from_account: chequing, description: 'groceries', tags: 'food', amount: 10, payment_on: Date.today })
  ch2 = Payment.create({ person_id: demo.id, from_account: chequing, description: 'movie', tags: 'entertainment', amount: 10, payment_on: Date.today - 1 })
  ch3 = Payment.create({ person_id: demo.id, to_account: chequing, description: 'salary', amount: 1000, payment_on: Date.today - 2 })
  ch4 = Payment.create({ person_id: demo.id, from_account: chequing, description: 'rent', tags: 'rent', amount: 500, payment_on: Date.today - 10 })
  sa1 = Payment.create({ person_id: demo.id, from_account: savings, description: 'groceries', tags: 'food', amount: 20, payment_on: Date.today })
  sa2 = Payment.create({ person_id: demo.id, from_account: savings, description: 'bike stuff', tags: 'recreation', amount: 20, payment_on: Date.today - 1 })
  sa3 = Payment.create({ person_id: demo.id, to_account: savings, description: 'birthday gift', tags: 'gift', amount: 200, payment_on: Date.today - 2 })
  vi1 = Payment.create({ person_id: demo.id, from_account: visa, description: 'clothes', tags: 'clothes', amount: 30, payment_on: Date.today })
  vi2 = Payment.create({ person_id: demo.id, from_account: visa, description: 'groceries', tags: 'food', amount: 30, payment_on: Date.today - 1 })
  vi3 = Payment.create({ person_id: demo.id, to_account: visa, description: 'refund', amount: 30, payment_on: Date.today - 2 })
  vi4 = Payment.create({ person_id: demo.id, from_account: visa, description: 'clothes', tags: 'clothes', amount: 30, payment_on: Date.today - 4 })
  vi5 = Payment.create({ person_id: demo.id, from_account: visa, description: 'clothes', tags: 'clothes', amount: 30, payment_on: Date.today - 5 })
  vi6 = Payment.create({ person_id: demo.id, from_account: visa, description: 'clothes', tags: 'clothes', amount: 30, payment_on: Date.today - 6 })
  tr1 = Payment.create({ person_id: demo.id, from_account: chequing, to_account: visa, description: 'bill payment', amount: 30, payment_on: Date.today - 2 })
  tr2 = Payment.create({ person_id: demo.id, from_account: chequing, to_account: cash, description: 'atm', amount: 20, payment_on: Date.today - 3 })

  j1 = Journal.create({ person_id: demo.id, entry: 'first test entry', tags: 'test', entry_on: Date.today - 2 })
  j2 = Journal.create({ person_id: demo.id, entry: 'second test entry', tags: 'test', entry_on: Date.today - 3 })
  j3 = Journal.create({ person_id: demo.id, entry: 'third test entry', entry_on: Date.today - 4 })
  j4 = Journal.create({ person_id: demo.id, entry: 'fourth test entry', entry_on: Date.today - 5 })
  
  con1 = Connection.create({ person_id: demo.id, name: 'imdb', username: 'demo@raceweb.ca', password: 'clue', url: 'http://www.imdb.com', description: 'movie stuff', tags: 'movies' })
  con1 = Connection.create({ person_id: demo.id, name: 'pandora', username: 'demo@raceweb.ca', password: 'clue', url: 'http://www.pandora.com', description: 'all my music', tags: 'music' })
  con1 = Connection.create({ person_id: demo.id, name: 'cibc bank', username: 'demo@raceweb.ca', password: 'super secret', url: 'http://www.cibc.com', description: 'all my money', tags: 'bank' })

  m1 = Milestone.create({ person_id: demo.id, name: 'high school', milestone_at: 3.years.ago })
  m1 = Milestone.create({ person_id: demo.id, name: 'trip to mexico', milestone_at: 600.days.ago })
  m1 = Milestone.create({ person_id: demo.id, name: 'got muppet show job', milestone_at: 45.days.ago })
  m1 = Milestone.create({ person_id: demo.id, name: 'trip to austrailia', milestone_at: Date.today + 99 })
  
  puts "done demo_user task."
end