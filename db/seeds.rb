Lookup.create(category: 1, code: 'root', description: 'root')
Lookup.create(category: 1, code: 'work_type', description: 'workout types')
Lookup.create(category: 2, code: 'run', description: 'run')
Lookup.create(category: 2, code: 'bike', description: 'bike')
Lookup.create(category: 2, code: 'swim', description: 'swim')
Lookup.create(category: 2, code: 'other', description: 'other')
Lookup.create(category: 1, code: 'jour_type', description: 'journal entry type')
Lookup.create(category: 7, code: '1', description: 'default')
Lookup.create(category: 7, code: '2', description: 'quote')
Lookup.create(category: 7, code: '3', description: 'other')
Lookup.create(category: 1, code: 'priority', description: 'priority')
Lookup.create(category: 11, code: '1', description: 'low')
Lookup.create(category: 11, code: '2', description: 'medium')
Lookup.create(category: 11, code: '3', description: 'high')
Lookup.create(category: 11, code: '4', description: 'critical')
Lookup.create(category: 1, code: 'task_type', description: 'task types')
Lookup.create(category: 16, code: '1', description: 'home')
Lookup.create(category: 16, code: '2', description: 'other')
Lookup.create(category: 16, code: '3', description: 'tccf')
Lookup.create(category: 16, code: '4', description: 'sidney')
Lookup.create(category: 16, code: '5', description: 'cadboro')
Lookup.create(category: 16, code: '6', description: 'layritz')
Lookup.create(category: 16, code: '7', description: 'raceweb')
Lookup.create(category: 16, code: '8', description: 'race')
Lookup.create(category: 1, code: 'route', description: 'route')
Lookup.create(category: 25, code: '115415', description: 'esquimalt run (14)')
Lookup.create(category: 25, code: '488297', description: 'christmas hill run (13)')
Lookup.create(category: 25, code: '115277', description: 'waterfront ride')
Lookup.create(category: 25, code: '1077154 ', description: 'peninsula,path,waterfront')
Lookup.create(category: 25, code: '491770', description: 'songhees run')
Lookup.create(category: 25, code: '115570', description: 'bear hill run')
Lookup.create(category: 25, code: '649633', description: 'selkirk run (7)')
Lookup.create(category: 25, code: '702047', description: 'breakwater run (14)')
Lookup.create(category: 25, code: '817509', description: 'gorge cuthbert run (12)')
Lookup.create(category: 25, code: '782559', description: 'mt doug ritechs bogg run (24)')
Lookup.create(category: 1, code: 'freq', description: 'frequency')
Lookup.create(category: 36, code: '1', description: 'daily')
Lookup.create(category: 36, code: '7', description: 'weekly')
Lookup.create(category: 36, code: '14', description: 'biweekly')
Lookup.create(category: 36, code: '15', description: 'twice monthly')
Lookup.create(category: 36, code: '30', description: 'monthly')
Lookup.create(category: 36, code: '365', description: 'annualy')

Person.delete_all
adam = Person.create(
  username: 'adam', password: 'adam_pass', password_confirmation: 'adam_pass', born_on: 35.years.ago,
  authority: '3', email: 'adam@raceweb.ca', map_center: '48.468141,-123.358612', phone: '+12508812818'
)
quinn = Person.create(
  username: 'quinn', password: 'quinn_pass', password_confirmation: 'quinn_pass', born_on: 25.years.ago,
  authority: '2', map_center: '48.468141,-123.358612', phone: '+12508580600'
)
Person.create(
  username: 'dave', password: 'dave_pass', password_confirmation: 'dave_pass', born_on: 55.years.ago,
  authority: '2', map_center: '48.468141,-123.358612'
)
Person.create(
  username: 'cate', password: 'cate_pass', password_confirmation: 'cate_pass', born_on: 39.years.ago,
  authority: '2', map_center: '48.468141,-123.358612', phone: '+12505894719'
)

#########################################################
# links
#########################################################
adam.links.create(
  url: 'http://www.nba.com', name: 'nba', tags: 'sports', comments: 'stupid league', clicks: 15,
  last_clicked_on: Time.zone.today - 10, expires_on: nil
)
adam.links.create(
  url: 'http://www.nhl.com', name: 'nhl', tags: 'sports', comments: 'greedy fuckers', clicks: 5,
  last_clicked_on: Time.zone.today - 11, expires_on: nil
)
adam.tag('link', 'sports')
quinn.links.create(
  url: 'http://www.steam.com', name: 'steam', tags: 'games', clicks: 0, last_clicked_on: nil,
  expires_on: nil
)
quinn.tag('link', 'games')

#########################################################
# contacts
#########################################################
adam.contacts.create(
  name: 'mom', email: 'lizburke48@hotmail.com', phone_home: '250-347-9021', phone_work: '250-342-6416',
  address: 'box 100', city: 'radium', tags: 'family', comments: 'makes cookies'
)
adam.contacts.create(
  name: 'dad', email: 'jerrylawr@gmail.com', phone_home: '250-344-6584', phone_work: '250-344-6584',
  address: 'box 200', city: 'golden', tags: 'family', comments: 'makes houses'
)
adam.contacts.create(
  name: 'cate', email: 'cate@raceweb.ca', phone_home: '250-658-4719', phone_work: '250-342-6416',
  address: '1175 gerda', city: 'victoria', tags: 'family', comments: 'makes crafts'
)
adam.contacts.create(
  name: 'colin', email: 'colin@raceweb.ca', phone_home: '250-658-4719', phone_work: '250-342-6416',
  address: '1175 gerda', city: 'victoria', tags: 'family', comments: 'makes trouble'
)
adam.contacts.create(
  name: 'quinn', email: 'quinn@raceweb.ca', phone_home: '250-414-0106', phone_work: '250-342-6416',
  address: '123 paradise st', city: 'victoria', tags: 'family', comments: 'makes nothing'
)
adam.contacts.create(
  name: 'else', email: 'else@raceweb.ca', phone_home: '250-414-0106', phone_work: '250-342-6416',
  address: '123 paradise st', city: 'victoria', tags: 'family', comments: 'makes cookies'
)
adam.contacts.create(
  name: 'darby', email: 'darby@raceweb.ca', phone_home: '250-881-2818', phone_work: '250-342-6416',
  address: '42-330 tyee rd', city: 'victoria', tags: 'dog', comments: 'makes poop'
)
adam.contacts.create(
  name: 'chloe', email: 'chloe@raceweb.ca', phone_home: '250-658-4719', phone_work: '250-342-6416',
  address: 'box 100', city: 'victoria', tags: 'dog', comments: 'makes poop'
)
adam.contacts.create(
  name: 'mark', email: 'mark@raceweb.ca', phone_home: '250-686-3325', phone_work: '250-342-6416',
  address: '123 belton ave', city: 'victoria', tags: 'friend', comments: 'makes music'
)
adam.contacts.create(
  name: 'eva', email: 'eva@raceweb.ca', phone_home: '250-514-4727', phone_work: '250-342-6416',
  address: '123 belton ave', city: 'victoria', tags: 'friend', comments: 'makes dinner'
)
adam.tag('contact', 'family friend dog')
quinn.contacts.create(
  name: 'mom', email: 'mom@raceweb.ca', phone_home: '250-414-0106', phone_work: '250-342-6416',
  address: '123 paradise st', city: 'victoria', tags: 'family', comments: 'makes dinner'
)
quinn.contacts.create(
  name: 'dad', email: 'dad@raceweb.ca', phone_home: '250-881-2818', phone_work: '250-342-6416',
  address: '42-330 tyee rd', city: 'victoria', tags: 'family', comments: 'makes dinner'
)
quinn.tag('contact', 'family')

#########################################################
# workouts
#########################################################
Lookup.where(category: 2, code: 'run').first._id
Lookup.where(category: 2, code: 'bike').first._id
adam.workouts.create(
  location: 'thetis', duration: 60, distance: 10, intensity: 5, tags: 'run', workout_on:
  Time.zone.today - 1, description: 'easy run around thetis'
)
adam.workouts.create(
  location: 'elk lake', duration: 60, distance: 10, intensity: 5, tags: 'run', workout_on:
  Time.zone.today - 4, description: 'easy run around elk lake'
)
adam.workouts.create(
  location: 'goose', duration: 60, distance: 40, intensity: 5, tags: 'bike', workout_on:
  Time.zone.today - 5, description: 'easy ride on the goose'
)
adam.tag('workout', 'run bike')
quinn.workouts.create(
  location: 'crag x', duration: 60, intensity: 5, tags: 'climb', workout_on:
  Time.zone.today - 1, description: 'climbed up, fell down'
)
quinn.tag('workout', 'climb')

#########################################################
# payments
#########################################################
chequing = adam.accounts.create(name: 'chequing', price: 1, units: 1000, active: true)
savings  = adam.accounts.create(name: 'savings', price: 1, units: 200, active: true)
visa     = adam.accounts.create(name: 'visa', price: 1, units: -200, active: true)
adam.payments.create(
  from_account: chequing, description: 'groceries', tags: 'food', amount: 10, payment_on: Time.zone.today
)
adam.payments.create(
  from_account: chequing, description: 'movie', tags: 'entertainment', amount: 10, payment_on: Time.zone.today - 1
)
adam.payments.create(
  to_account: chequing, description: 'salary', amount: 1000, payment_on: Time.zone.today - 2
)
adam.payments.create(
  from_account: savings, description: 'groceries', tags: 'food', amount: 20, payment_on: Time.zone.today
)
adam.payments.create(
  from_account: savings, description: 'bike stuff', tags: 'recreation', amount: 20, payment_on: Time.zone.today - 1
)
adam.payments.create(
  to_account: savings, description: 'birthday gift', tags: 'gift', amount: 200, payment_on: Time.zone.today - 2
)
adam.payments.create(
  from_account: visa, description: 'clothes', tags: 'clothes', amount: 30, payment_on: Time.zone.today
)
adam.payments.create(
  from_account: visa, description: 'groceries', tags: 'food', amount: 30, payment_on: Time.zone.today - 1
)
adam.payments.create(
  to_account: visa, description: 'refund', amount: 30, payment_on: Time.zone.today - 2
)
adam.payments.create(
  from_account: chequing, to_account: visa, description: 'bill payment', amount: 30, payment_on: Time.zone.today - 2
)
adam.tag('payment', 'food entertainment recreation gift clothes')
quinn_savings = quinn.accounts.create(name: 'savings', price: 1, units: 100, active: true)
quinn.payments.create(
  from_account: quinn_savings, description: 'movie', tags: 'entertainment', amount: 15, payment_on: Time.zone.today
)
quinn.tag('payment', 'entertainment')

#########################################################
# journals
#########################################################
default = Lookup.where(category: 7, code: '1').first._id
adam.journals.create(journal_type: default, entry: 'first test entry', tags: 'test', entry_on: Time.zone.today - 2)
adam.journals.create(journal_type: default, entry: 'second test entry', tags: 'test', entry_on: Time.zone.today - 3)
adam.journals.create(journal_type: default, entry: 'third test entry', entry_on: Time.zone.today - 4)
adam.journals.create(journal_type: default, entry: 'fourth test entry', entry_on: Time.zone.today - 5)
adam.tag('journal', 'test')
quinn.journals.create(journal_type: default, entry: 'quinn test entry', entry_on: Time.zone.today - 1)
quinn.tag('journal', 'test')

#########################################################
# connections
#########################################################
adam.connections.create(
  name: 'imdb', username: 'adam@raceweb.ca', password: 'clue', url: 'http://www.imdb.com',
  description: 'movie stuff', tags: 'movies'
)
adam.connections.create(
  name: 'pandora', username: 'adam@raceweb.ca', password: 'clue', url: 'http://www.pandora.com',
  description: 'all my music', tags: 'music'
)
adam.connections.create(
  name: 'cibc bank', username: 'adam@raceweb.ca', password: 'super secret', url: 'http://www.cibc.com',
  description: 'all my money', tags: 'bank'
)
adam.tag('connection', 'movies music bank')
quinn.connections.create(
  name: 'rbc bank', username: 'quinn@raceweb.ca', password: 'super secret', url: 'http://www.rbc.com',
  description: 'all my money', tags: 'bank'
)
quinn.tag('connection', 'bank')

#########################################################
# milestones
#########################################################
adam.milestones.create(name: 'high school', milestone_at: Time.zone.now - 30.years)
adam.milestones.create(name: 'quinn born', milestone_at: Time.zone.now - 21.years)
adam.milestones.create(name: 'else born', milestone_at: Time.zone.now - 19.years)
adam.milestones.create(name: 'trip to florida', milestone_at: Time.zone.now - 3.years)
quinn.milestones.create(name: 'climbing trip', milestone_at: Time.zone.now - 1.year)

#########################################################
# reminders
#########################################################
low  = Lookup.where(category: 11, code: '1').first._id
high = Lookup.where(category: 11, code: '3').first._id
home = Lookup.where(category: 16, code: '1').first._id
adam.reminders.create(
  description: 'weed the garden', tags: 'home', due_at: Time.zone.today, reminder_type_id: home, priority_id: low
)
adam.reminders.create(
  description: 'groceries', tags: 'home', due_at: Time.zone.today, reminder_type_id: home, priority_id: high
)
adam.reminders.create(
  description: 'spending committee meeting', tags: 'coop', due_at: Time.zone.today + 1, reminder_type_id: home,
  priority_id: low
)
adam.reminders.create(
  description: 'doctor appointment', tags: 'home', due_at: Time.zone.today + 1, reminder_type_id: home,
  priority_id: high
)
adam.reminders.create(
  description: 'groceries', tags: 'home', due_at: Time.zone.today + 1, reminder_type_id: home, priority_id: low
)
adam.reminders.create(
  description: 'parent teacher meeting', tags: 'school', due_at: Time.zone.today + 2, reminder_type_id: home,
  priority_id: high
)
adam.reminders.create(
  description: 'download something', tags: 'home', due_at: Time.zone.today + 2, reminder_type_id: home, priority_id: low
)
adam.reminders.create(
  description: 'buy plane tickets', tags: 'home', due_at: Time.zone.today + 2, reminder_type_id: home, priority_id: low
)
adam.reminders.create(
  description: 'pay hydro bill', tags: 'home', due_at: Time.zone.today + 3, reminder_type_id: home, priority_id: high
)
adam.reminders.create(
  description: 'kids to jen\'s house', tags: 'home', due_at: Time.zone.today + 4, reminder_type_id: home,
  priority_id: low
)
adam.tag('reminder', 'home coop school')
quinn.reminders.create(
  description: 'climbing competition', tags: 'climb', due_at: Time.zone.now + 6.hours, reminder_type_id: home,
  priority_id: low
)
quinn.tag('reminder', 'climb')
