desc "build a demo user"

task :demo_user => :environment do

  demo = Person.where(username: 'demo').first
  demo.destroy if demo

  demo  = Person.create({ username: 'demo', password: 'demo', password_confirmation: 'demo', born_on: 20.years.ago, authority: '2', email: 'demo@raceweb.ca', map_center: '48.468141,-123.358612', phone: '+12508812818' })

  demo.links.create({ url: 'http://www.nba.com', name: 'nba', tags: 'sports', comments: 'gets worse every year', clicks: 15, last_clicked_on: '2013-02-01', expires_on: nil })
  demo.links.create({ url: 'http://www.nhl.com', name: 'nhl', tags: 'sports', comments: 'boycotting', clicks: 5, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://www.imgur.com', name: 'imgur', tags: 'pictures', comments: 'pictures for everything', clicks: 5, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://www.reddit.com', name: 'reddit', tags: 'news', comments: 'careful if you have stuff to do', clicks: 22, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://www.cnn.com', name: 'cnn', tags: 'news', comments: 'ratings based news', clicks: 19, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://www.cbc.ca', name: 'cbc', tags: 'news', comments: 'canadian news', clicks: 33, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://www.cyclingnews.com', name: 'cycling news', tags: 'cycling news', comments: 'everything cycling', clicks: 18, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://www.imdb.com', name: 'nhl', tags: 'movies', comments: 'everything movies', clicks: 11, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://www.rottentomatoes.com', name: 'rotten tomatoes', tags: 'movies', comments: 'good ratings', clicks: 9, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://rubyonrails.org', name: 'rails', tags: 'dev rails', comments: 'web framework', clicks: 12, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://railscasts.com', name: 'railscasts', tags: 'dev rails', comments: 'video tutorials on everything', clicks: 24, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://www.w3schools.com', name: 'w3schools', tags: 'dev css', comments: 'simple reference', clicks: 2, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://www.codeschool.com', name: 'codeschool', tags: 'dev', comments: 'video tutorials', clicks: 3, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://twitter.github.com/bootstrap/index.html', name: 'bootstrap', tags: 'dev css', comments: 'twitter css framework', clicks: 15, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.links.create({ url: 'http://www.jquery.com', name: 'jquery', tags: 'dev javascript', comments: 'javascript framework', clicks: 5, last_clicked_on: '2013-02-10', expires_on: nil })
  demo.tag('link', 'sports pictures news cycling movies dev rails css javascript')

  demo.contacts.create({ name: 'kermit', email: 'kermit@raceweb.ca', phone_home: '250-347-9021', phone_work: '250-342-6416', address: '123 fake st', city: 'victoria', tags: 'frog friend', comments: 'why does he hang out with that pig?' })
  demo.contacts.create({ name: 'gonzo', email: 'gonzo@raceweb.ca', phone_home: '250-344-6584', phone_work: '250-344-6584', address: '123 sesame st', city: 'victoria', tags: 'family', comments: 'is that thing even a nose?' })
  demo.contacts.create({ name: 'fozzie', email: 'fozzie@raceweb,ca', phone_home: '250-658-4719', phone_work: '250-342-6416', address: '123 fake st', city: 'victoria', tags: 'family', comments: 'just smile and nod when he starts telling jokes' })
  demo.contacts.create({ name: 'floyd', email: 'floyd@raceweb,ca', phone_home: '250-658-4719', phone_work: '250-342-6416', address: '123 fake st', city: 'victoria', tags: 'friend band', comments: 'he hold that band together' })
  demo.contacts.create({ name: 'scooter', email: 'scooter@raceweb,ca', phone_home: '250-414-0106', phone_work: '250-342-6416', address: '123 fake st', city: 'victoria', tags: 'family', comments: 'good helper' })
  demo.tag('contact', 'frog friend family band')

  run   = Lookup.where(code: 'run').first._id
  bike  = Lookup.where(code: 'bike').first._id
  swim  = Lookup.where(code: 'swim').first._id
  other = Lookup.where(code: 'other').first._id
  w1 = demo.workouts.create({ location: 'thetis', duration: 60, distance: 10, intensity: 5, tags: 'run', workout_on: '2013-02-01', weight: 165, description: 'easy run around thetis' })
  w2 = demo.workouts.create({ location: 'elk lake', duration: 60, distance: 10, intensity: 5, tags: 'run', workout_on: '2013-02-02', weight: 168, description: 'easy run around elk lake' })
  w3 = demo.workouts.create({ location: 'goose', duration: 60, distance: 40, intensity: 5, tags: 'bike', workout_on: '2013-02-03', description: 'easy ride on the goose' })
  demo.tag('workout', 'run bike')

  chequing = demo.accounts.create({ name: 'chequing', price: 1, units: 1000, active: true })
  savings  = demo.accounts.create({ name: 'savings', price: 1, units: 200, active: true })
  visa     = demo.accounts.create({ name: 'visa', price: 1, units: -200, active: true })
  cash     = demo.accounts.create({ name: 'cash', price: 1, units: 300, active: true })
  ch1 = demo.payments.create({ from_account: chequing, description: 'groceries', tags: 'food', amount: 10, payment_on: Date.today })
  ch2 = demo.payments.create({ from_account: chequing, description: 'movie', tags: 'entertainment', amount: 10, payment_on: Date.today - 1 })
  ch3 = demo.payments.create({ to_account: chequing, description: 'salary', amount: 1000, payment_on: Date.today - 2 })
  ch4 = demo.payments.create({ from_account: chequing, description: 'rent', tags: 'rent', amount: 500, payment_on: Date.today - 10 })
  sa1 = demo.payments.create({ from_account: savings, description: 'groceries', tags: 'food', amount: 20, payment_on: Date.today })
  sa2 = demo.payments.create({ from_account: savings, description: 'bike stuff', tags: 'recreation', amount: 20, payment_on: Date.today - 1 })
  sa3 = demo.payments.create({ to_account: savings, description: 'birthday gift', tags: 'gift', amount: 200, payment_on: Date.today - 2 })
  vi1 = demo.payments.create({ from_account: visa, description: 'clothes', tags: 'clothes', amount: 30, payment_on: Date.today })
  vi2 = demo.payments.create({ from_account: visa, description: 'groceries', tags: 'food', amount: 30, payment_on: Date.today - 1 })
  vi3 = demo.payments.create({ to_account: visa, description: 'refund', amount: 30, payment_on: Date.today - 2 })
  vi4 = demo.payments.create({ from_account: visa, description: 'clothes', tags: 'clothes', amount: 30, payment_on: Date.today - 4 })
  vi5 = demo.payments.create({ from_account: visa, description: 'clothes', tags: 'clothes', amount: 30, payment_on: Date.today - 5 })
  vi6 = demo.payments.create({ from_account: visa, description: 'clothes', tags: 'clothes', amount: 30, payment_on: Date.today - 6 })
  tr1 = demo.payments.create({ from_account: chequing, to_account: visa, description: 'bill payment', amount: 30, payment_on: Date.today - 2 })
  tr2 = demo.payments.create({ from_account: chequing, to_account: cash, description: 'atm', amount: 20, payment_on: Date.today - 3 })
  demo.tag('pament', 'food entertainment rent recreation gift clothes food')

  default = Lookup.where(category: 7, code: '1').first._id
  j1 = demo.journals.create({ journal_type_id: default, entry: 'first test entry', tags: 'test', entry_on: Date.today - 2 })
  j2 = demo.journals.create({ journal_type_id: default, entry: 'second test entry', tags: 'test', entry_on: Date.today - 3 })
  j3 = demo.journals.create({ journal_type_id: default, entry: 'third test entry', entry_on: Date.today - 4 })
  j4 = demo.journals.create({ journal_type_id: default, entry: 'fourth test entry', entry_on: Date.today - 5 })
  demo.tag('journal', 'test')

  con1 = demo.connections.create({ name: 'imdb', username: 'demo@raceweb.ca', password: 'clue', url: 'http://www.imdb.com', description: 'movie stuff', tags: 'movies' })
  con1 = demo.connections.create({ name: 'pandora', username: 'demo@raceweb.ca', password: 'clue', url: 'http://www.pandora.com', description: 'all my music', tags: 'music' })
  con1 = demo.connections.create({ name: 'cibc bank', username: 'demo@raceweb.ca', password: 'super secret', url: 'http://www.cibc.com', description: 'all my money', tags: 'bank' })
  demo.tag('connection', 'movies music bank')

  m1 = demo.milestones.create({ name: 'high school', milestone_at: 3.years.ago })
  m1 = demo.milestones.create({ name: 'trip to mexico', milestone_at: 600.days.ago })
  m1 = demo.milestones.create({ name: 'got muppet show job', milestone_at: 45.days.ago })
  m1 = demo.milestones.create({ name: 'trip to austrailia', milestone_at: Date.today + 99 })

  low  = Lookup.where(category: 11, code: '1').first._id
  high = Lookup.where(category: 11, code: '3').first._id
  home = Lookup.where(category: 16, code: '1').first._id

  r1 = demo.reminders.create({ description: 'weed the garden', tags: 'home', due_at: Date.today, reminder_type_id: home, priority_id: low })
  r2 = demo.reminders.create({ description: 'groceries', tags: 'home', due_at: Date.today, reminder_type_id: home, priority_id: high })
  r3 = demo.reminders.create({ description: 'spending committee meeting', tags: 'coop', due_at: Date.today + 1, reminder_type_id: home, priority_id: low })
  r4 = demo.reminders.create({ description: 'doctor appointment', tags: 'home', due_at: Date.today + 1, reminder_type_id: home, priority_id: high })
  r5 = demo.reminders.create({ description: 'groceries', tags: 'home', due_at: Date.today + 1, reminder_type_id: home, priority_id: low })
  r6 = demo.reminders.create({ description: 'parent teacher meeting', tags: 'school', due_at: Date.today + 2, reminder_type_id: home, priority_id: high })
  r7 = demo.reminders.create({ description: 'download something', tags: 'home', due_at: Date.today + 2, reminder_type_id: home, priority_id: low })
  r8 = demo.reminders.create({ description: 'buy plane tickets', tags: 'home', due_at: Date.today + 2, reminder_type_id: home, priority_id: low })
  r9 = demo.reminders.create({ description: 'pay hydro bill', tags: 'home', due_at: Date.today + 3, reminder_type_id: home, priority_id: high })
  r10 = demo.reminders.create({ description: 'kids to jen\'s house', tags: 'home', due_at: Date.today + 4, priority_id: home, priority_id: low })
  demo.tag('reminder', 'home coop school')

  puts "done demo_user task."
end