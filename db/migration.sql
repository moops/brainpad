-- lookups

insert into `brainpad_development`.`people` (name,user_name,password,mail_url,banking_url,map_center,authority,born_on,last_login_at,created_at,updated_at)
select p.name, p.user_name, p.password, p.mail_url, p.banking_url, p.map_center, p.authority, p.birth_on, p.last_login_on, p.created_on, p.updated_on
from `brainpad`.`people` p;

insert into `brainpad_development`.`accounts` (id, name, url, price_url, description, units, price, active, person_id, created_at, updated_at)
select a.id, a.name, a.url, a.price_url, a.description, a.units, a.price, a.active, a.person_id, '2005-01-01', '2005-01-01'
from `brainpad`.`accounts` a;

insert into `brainpad_development`.`account_prices` (account_id, price, price_on, created_at, updated_at)
select a.account_id, a.price, a.price_on, a.price_on, a.price_on
from `brainpad`.`account_prices` a;

insert into `brainpad_development`.`connections` (name,username,password,url,description,person_id,created_at,updated_at)
select c.name, c.username, c.password, c.url, c.description, c.person_id, '2005-01-01', c.updated_on
from `brainpad`.`connections` c;

insert into `brainpad_development`.`contacts` (name,email,phone_home,phone_work,phone_cell,address,city,tags,comments,person_id,created_at,updated_at)
select concat(c.first_name, ' ', c.last_name) , c.email, c.phone, null, c.phone_cell, c.address, c.city, c.tags, c.comments, c.person_id, c.created_on, c.updated_on
from `brainpad`.`contacts` c;

insert into `brainpad_development`.`journals` (entry,entry_on,journal_type,person_id,created_at,updated_at)
select j.entry, j.entry_on, j.journal_type, j.person_id, j.created_on, c.updated_on
from `brainpad`.`journal` j;

insert into `brainpad_development`.`links` (url,name,tags,comments,last_clicked,expires_on,person_id,created_at,updated_at)
select l.url, l.name, l.tags, l.comments, l.last_clicked, l.expires_on, l.person_id, l.created_on, l.updated_on
from `brainpad`.`links` l;

insert into `brainpad_development`.`payments` (description,tags,amount,payment_on,frequency,until,account_id,transfer_from,person_id,created_at,updated_at)
select p.description, p.tags, p.amount, p.payment_on, null, null, p.account_id, p.transfer_from, 1, p.created_at, p.updated_at
from `brainpad`.`payments` p;

insert into `brainpad_development`.`reminders` (description,done,priority,reminder_type,interval,repeat_until,due_on,person_id,created_at,updated_at)
select r.description, r.done, r.priority, r.reminder_type, r.interval, r.repeat_until, r.due_date, r.person_id, r.created_on, r.updated_on
from `brainpad`.`reminders` r;

insert into `brainpad_development`.`workouts` (location,race,route,description,duration,intensity,weight,distance,workout_type,workout_on,person_id,created_at,updated_at)
select w.location, w.race, w.route, w.description, w.duration, w.intensity, w.weight, w.distance, w.workout_type, w.workout_on, w.person_id, w.created_on, w.updated_on
from `brainpad`.`workouts` w;
