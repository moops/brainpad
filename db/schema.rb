# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100429213552) do

  create_table "account_prices", :force => true do |t|
    t.integer  "account_id"
    t.float    "price"
    t.date     "price_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "price_url"
    t.string   "description"
    t.float    "units"
    t.float    "price"
    t.boolean  "active"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "connections", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password"
    t.string   "url"
    t.text     "description"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_home"
    t.string   "phone_work"
    t.string   "phone_cell"
    t.string   "address"
    t.string   "city"
    t.string   "tags"
    t.text     "comments"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "journals", :force => true do |t|
    t.text     "entry"
    t.date     "entry_on"
    t.integer  "journal_type"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.string   "tags"
    t.string   "comments"
    t.integer  "clicks"
    t.datetime "last_clicked"
    t.datetime "expires_on"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lookups", :force => true do |t|
    t.integer "category"
    t.string  "code"
    t.string  "description"
  end

  create_table "milestones", :force => true do |t|
    t.string   "name"
    t.date     "milestone_at"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.string   "description"
    t.string   "tags"
    t.float    "amount"
    t.date     "payment_on"
    t.integer  "frequency"
    t.date     "until"
    t.integer  "account_id"
    t.integer  "transfer_from"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "user_name"
    t.string   "password"
    t.string   "mail_url"
    t.string   "banking_url"
    t.string   "map_center"
    t.integer  "authority"
    t.date     "born_on"
    t.datetime "last_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reminders", :force => true do |t|
    t.text     "description"
    t.boolean  "done"
    t.integer  "priority"
    t.integer  "reminder_type"
    t.integer  "interval"
    t.date     "repeat_until"
    t.date     "due_on"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workouts", :force => true do |t|
    t.string   "location"
    t.string   "race"
    t.string   "route"
    t.text     "description"
    t.integer  "duration"
    t.integer  "intensity"
    t.integer  "weight"
    t.float    "distance"
    t.integer  "workout_type"
    t.date     "workout_on"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
