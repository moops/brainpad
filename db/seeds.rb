Lookup.create({ category: 1, code: 'root', description: 'root' })
Lookup.create({ category: 1, code: 'work_type', description: 'workout types' })
Lookup.create({ category: 2, code: 'run', description: 'run' })
Lookup.create({ category: 2, code: 'bike', description: 'bike' })
Lookup.create({ category: 2, code: 'swim', description: 'swim' })
Lookup.create({ category: 2, code: 'other', description: 'other' })
Lookup.create({ category: 1, code: 'jour_type', description: 'journal entry type' })
Lookup.create({ category: 7, code: '1', description: 'default' })
Lookup.create({ category: 7, code: '2', description: 'quote' })
Lookup.create({ category: 7, code: '3', description: 'other' })
Lookup.create({ category: 1, code: 'priority', description: 'priority' })
Lookup.create({ category: 11, code: '1', description: 'low' })
Lookup.create({ category: 11, code: '2', description: 'medium' })
Lookup.create({ category: 11, code: '3', description: 'high' })
Lookup.create({ category: 11, code: '4', description: 'critical' })
Lookup.create({ category: 1, code: 'task_type', description: 'task types' })
Lookup.create({ category: 16, code: '1', description: 'home' })
Lookup.create({ category: 16, code: '2', description: 'other' })
Lookup.create({ category: 16, code: '3', description: 'tccf' })
Lookup.create({ category: 16, code: '4', description: 'sidney' })
Lookup.create({ category: 16, code: '5', description: 'cadboro' })
Lookup.create({ category: 16, code: '6', description: 'layritz' })
Lookup.create({ category: 16, code: '7', description: 'raceweb' })
Lookup.create({ category: 16, code: '8', description: 'race' })
Lookup.create({ category: 1, code: 'route', description: 'route' })
Lookup.create({ category: 25, code: '115415', description: 'esquimalt run (14)' })
Lookup.create({ category: 25, code: '488297', description: 'christmas hill run (13)' })
Lookup.create({ category: 25, code: '115277', description: 'waterfront ride' })
Lookup.create({ category: 25, code: '1077154 ', description: 'peninsula,path,waterfront' })
Lookup.create({ category: 25, code: '491770', description: 'songhees run' })
Lookup.create({ category: 25, code: '115570', description: 'bear hill run' })
Lookup.create({ category: 25, code: '649633', description: 'selkirk run (7)' })
Lookup.create({ category: 25, code: '702047', description: 'breakwater run (14)' })
Lookup.create({ category: 25, code: '817509', description: 'gorge cuthbert run (12)' })
Lookup.create({ category: 25, code: '782559', description: 'mt doug ritechs bogg run (24)' })
Lookup.create({ category: 1, code: 'freq', description: 'frequency' })
Lookup.create({ category: 36, code: '1', description: 'daily' })
Lookup.create({ category: 36, code: '7', description: 'weekly' })
Lookup.create({ category: 36, code: '14', description: 'biweekly' })
Lookup.create({ category: 36, code: '15', description: 'twice monthly' })
Lookup.create({ category: 36, code: '30', description: 'monthly' })
Lookup.create({ category: 36, code: '365', description: 'annualy' })

Person.delete_all
adam  = Person.create({ username: 'adam', password: 'adam_pass', password_confirmation: 'adam_pass', born_on: 35.years.ago, authority: '3', email: 'adam@raceweb.ca', map_center: '48.468141,-123.358612', phone: '+12508812818' })
adam.save
quinn = Person.create({ username: 'quinn', password: 'quinn_pass', password_confirmation: 'quinn_pass', born_on: 45.years.ago, authority: '3', map_center: '48.468141,-123.358612', phone: '+12508580600' })
quinn.save
dave  = Person.create({ username: 'dave', password: 'dave_pass', password_confirmation: 'dave_pass', born_on: 55.years.ago, authority: '3', map_center: '48.468141,-123.358612' })
dave.save
cate  = Person.create({ username: 'cate', password: 'cate_pass', password_confirmation: 'cate_pass', born_on: 39.years.ago, authority: '3', map_center: '48.468141,-123.358612', phone: '+12505894719' })
cate.save

adam.links.create({ url: 'http://www.nba.com', name: 'nba', tags: 'sports', comments: 'stupid league', clicks: 15, last_clicked_on: Date.today - 10, expires_on: nil })
adam.links.create({ url: 'http://www.nhl.com', name: 'nhl', tags: 'sports', comments: 'greedy fuckers', clicks: 5, last_clicked_on: Date.today - 11, expires_on: nil })
adam.tag('link', 'sports')

adam.contacts.create({ name: 'mom', email: 'lizburke48@hotmail.com', phone_home: '250-347-9021', phone_work: '250-342-6416', address: 'box 100', city: 'radium', tags: 'family', comments: 'makes cookies' })
adam.contacts.create({ name: 'dad', email: 'jerrylawr@gmail.com', phone_home: '250-344-6584', phone_work: '250-344-6584', address: 'box 200', city: 'golden', tags: 'family', comments: 'makes houses' })
adam.contacts.create({ name: 'cate', email: 'cate@raceweb.ca', phone_home: '250-658-4719', phone_work: '250-342-6416', address: '1175 gerda', city: 'victoria', tags: 'family', comments: 'makes crafts' })
adam.contacts.create({ name: 'colin', email: 'colin@raceweb.ca', phone_home: '250-658-4719', phone_work: '250-342-6416', address: '1175 gerda', city: 'victoria', tags: 'family', comments: 'makes trouble' })
adam.contacts.create({ name: 'quinn', email: 'quinn@raceweb.ca', phone_home: '250-414-0106', phone_work: '250-342-6416', address: '123 paradise st', city: 'victoria', tags: 'family', comments: 'makes nothing' })
adam.contacts.create({ name: 'else', email: 'else@raceweb.ca', phone_home: '250-414-0106', phone_work: '250-342-6416', address: '123 paradise st', city: 'victoria', tags: 'family', comments: 'makes cookies' })
adam.contacts.create({ name: 'darby', email: 'darby@raceweb.ca', phone_home: '250-881-2818', phone_work: '250-342-6416', address: '42-330 tyee rd', city: 'victoria', tags: 'dog', comments: 'makes poop' })
adam.contacts.create({ name: 'chloe', email: 'chloe@raceweb.ca', phone_home: '250-658-4719', phone_work: '250-342-6416', address: 'box 100', city: 'victoria', tags: 'dog', comments: 'makes poop' })
adam.contacts.create({ name: 'mark', email: 'mark@raceweb.ca', phone_home: '250-686-3325', phone_work: '250-342-6416', address: '123 belton ave', city: 'victoria', tags: 'friend', comments: 'makes music' })
adam.contacts.create({ name: 'eva', email: 'eva@raceweb.ca', phone_home: '250-514-4727', phone_work: '250-342-6416', address: '123 belton ave', city: 'victoria', tags: 'friend', comments: 'makes dinner' })
adam.tag('contact', 'family friend dog')
quinn.contacts.create({ name: 'mom', email: 'mom@raceweb.ca', phone_home: '250-414-0106', phone_work: '250-342-6416', address: '123 paradise st', city: 'victoria', tags: 'family', comments: 'makes dinner' })
quinn.contacts.create({ name: 'dad', email: 'dad@raceweb.ca', phone_home: '250-881-2818', phone_work: '250-342-6416', address: '42-330 tyee rd', city: 'victoria', tags: 'family', comments: 'makes dinner' })
quinn.tag('contact', 'family')

run = Lookup.where(category: 2, code: 'run').first._id
bike = Lookup.where(category: 2, code: 'bike').first._id
w1 = adam.workouts.create({ location: 'thetis', duration: 60, distance: 10, intensity: 5, tags: 'run', workout_on: Date.today - 1, description: 'easy run around thetis' })
puts w1.new_record?
puts w1.errors.inspect
puts w1.inspect
w2 = adam.workouts.create({ location: 'elk lake', duration: 60, distance: 10, intensity: 5, tags: 'run', workout_on: Date.today - 2, description: 'easy run around elk lake' })
w3 = adam.workouts.create({ location: 'goose', duration: 60, distance: 40, intensity: 5, tags: 'bike', workout_on: Date.today - 4, description: 'easy ride on the goose' })
adam.tag('workout', 'run bike')

chequing = adam.accounts.create({ name: 'chequing', price: 1, units: 1000, active: true })
savings  = adam.accounts.create({ name: 'savings', price: 1, units: 200, active: true })
visa     = adam.accounts.create({ name: 'visa', price: 1, units: -200, active: true })
ch1 = adam.payments.create({ from_account: chequing, description: 'groceries', tags: 'food', amount: 10, payment_on: Date.today })
puts ch1.new_record?
puts ch1.errors.inspect
puts ch1.inspect
ch2 = adam.payments.create({ from_account: chequing, description: 'movie', tags: 'entertainment', amount: 10, payment_on: Date.today - 1 })
ch3 = adam.payments.create({ to_account: chequing, description: 'salary', amount: 1000, payment_on: Date.today - 2 })
sa1 = adam.payments.create({ from_account: savings, description: 'groceries', tags: 'food', amount: 20, payment_on: Date.today })
sa2 = adam.payments.create({ from_account: savings, description: 'bike stuff', tags: 'recreation', amount: 20, payment_on: Date.today - 1 })
sa3 = adam.payments.create({ to_account: savings, description: 'birthday gift', tags: 'gift', amount: 200, payment_on: Date.today - 2 })
vi1 = adam.payments.create({ from_account: visa, description: 'clothes', tags: 'clothes', amount: 30, payment_on: Date.today })
vi2 = adam.payments.create({ from_account: visa, description: 'groceries', tags: 'food', amount: 30, payment_on: Date.today - 1 })
vi3 = adam.payments.create({ to_account: visa, description: 'refund', amount: 30, payment_on: Date.today - 2 })
tr1 = adam.payments.create({ from_account: chequing, to_account: visa, description: 'bill payment', amount: 30, payment_on: Date.today - 2 })
adam.tag('payment', 'food entertainment recreation gift clothes')

default = Lookup.where(category: 7, code: '1').first._id
j1 = adam.journals.create({ journal_type: default, entry: 'first test entry', tags: 'test', entry_on: Date.today - 2 })
j2 = adam.journals.create({ journal_type: default, entry: 'second test entry', tags: 'test', entry_on: Date.today - 3 })
j3 = adam.journals.create({ journal_type: default, entry: 'third test entry', entry_on: Date.today - 4 })
j4 = adam.journals.create({ journal_type: default, entry: 'fourth test entry', entry_on: Date.today - 5 })
adam.tag('journal', 'test')

con1 = adam.connections.create({ name: 'imdb', username: 'adam@raceweb.ca', password: 'clue', url: 'http://www.imdb.com', description: 'movie stuff', tags: 'movies' })
con1 = adam.connections.create({ name: 'pandora', username: 'adam@raceweb.ca', password: 'clue', url: 'http://www.pandora.com', description: 'all my music', tags: 'music' })
con1 = adam.connections.create({ name: 'cibc bank', username: 'adam@raceweb.ca', password: 'super secret', url: 'http://www.cibc.com', description: 'all my money', tags: 'bank' })
adam.tag('connection', 'movies music bank')

m1 = adam.milestones.create({ name: 'high school', milestone_at: '1987-06-25' })
m1 = adam.milestones.create({ name: 'quinn born', milestone_at: '1996-03-01' })
m1 = adam.milestones.create({ name: 'else born', milestone_at: '1997-12-19' })
m1 = adam.milestones.create({ name: 'trip to florida', milestone_at: '2012-03-07' })

low  = Lookup.where(category: 11, code: '1').first._id
high = Lookup.where(category: 11, code: '3').first._id
home = Lookup.where(category: 16, code: '1').first._id
r1 = adam.reminders.create({ description: 'weed the garden', tags: 'home', due_at: Date.today, reminder_type_id: home, priority_id: low })
puts r1.new_record?
puts r1.errors.inspect
puts r1.inspect
r2 = adam.reminders.create({ description: 'groceries', tags: 'home', due_at: Date.today, reminder_type_id: home, priority_id: high })
r3 = adam.reminders.create({ description: 'spending committee meeting', tags: 'coop', due_at: Date.today + 1, reminder_type_id: home, priority_id: low })
r4 = adam.reminders.create({ description: 'doctor appointment', tags: 'home', due_at: Date.today + 1, reminder_type_id: home, priority_id: high })
r5 = adam.reminders.create({ description: 'groceries', tags: 'home', due_at: Date.today + 1, reminder_type_id: home, priority_id: low })
r6 = adam.reminders.create({ description: 'parent teacher meeting', tags: 'school', due_at: Date.today + 2, reminder_type_id: home, priority_id: high })
r7 = adam.reminders.create({ description: 'download something', tags: 'home', due_at: Date.today + 2, reminder_type_id: home, priority_id: low })
r8 = adam.reminders.create({ description: 'buy plane tickets', tags: 'home', due_at: Date.today + 2, reminder_type_id: home, priority_id: low })
r9 = adam.reminders.create({ description: 'pay hydro bill', tags: 'home', due_at: Date.today + 3, reminder_type_id: home, priority_id: high })
r10 = adam.reminders.create({ description: 'kids to jen\'s house', tags: 'home', due_at: Date.today + 4, reminder_type_id: home, priority_id: low })
adam.tag('reminder', 'home coop school')
