class SmsController < ApplicationController
  protect_from_forgery except: :create
  # POST /sms
  def create
    person = Person.find_by(phone: params[:From])
    head :unprocessable_entity unless person
    create_something(person, params[:Body])
    head :created
  end

  private

  def create_something(person, body)
    case body.partition(' ').first.downcase
      when 'reminder'
        parse_reminder(person, body)
      when 'workout'
        parse_workout(person, body)
      when 'journal'
        parse_journal(person, body)
      when 'payment'
        parse_payment(person, body)
      else
        logger.info "not sure what to create with:[#{body}]"
    end
  end

  def parse_reminder(person, body)
    m = /^\w+\s+(.*)(do:\s+(.*))$/.match(body)
    due_at = parse_time(m[3])
    reminder = person.reminders.create(description: m[1].strip, due_at: due_at)
    logger.info "created reminder[#{reminder.description}]"
  end

  def parse_workout(person, body)
    m = /^\w+\s+(?<tags>\w+)\s+(?<location>.*)\s+duration:\s+(?<duration>.*)\s+distance:\s+(?<distance>.*)\s+intensity:\s+(?<intensity>.*)\s+on:\s+(?<workout_on>.*)$/.match(body)
    attributes = attributes_for(m)
    # parse the workout_on
    attributes[:workout_on] = parse_time(attributes[:workout_on])
    workout = person.workouts.create(attributes)
    logger.info "created workout[#{workout}]"
  end

  def parse_journal(person, body)
    m = /^\w+\s+(?<entry>.*)\s+on:\s+(?<entry_on>.*)$/.match(body)
    attributes = attributes_for(m)
    # parse the entry_on
    attributes[:entry_on] = parse_time(attributes[:entry_on])
    journal = person.journals.create(attributes)
    logger.info "created journal entry[#{journal.entry[0,30]}]"
  end

  def parse_payment(person, body)
    m = /^\w+\s+\$(?<amount>\d+(\.\d{1,2})?)\s+(?<description>.*)\s+from:\s+(?<from_account>.*)\s+on:\s+(?<payment_on>.*)/.match(body)
    attributes = attributes_for(m)
    # find the from account
    attributes[:from_account] = person.accounts.find_by(name: /#{attributes[:from_account]}/) if attributes[:from_account]
    # parse the payment_on
    attributes[:payment_on] = parse_time(attributes[:payment_on])
    payment = person.payments.create(attributes)
    payment.apply
    logger.info "created payment[#{payment}]"
  end

  def parse_time(time)
    return unless time
    case time.downcase
      when 'now'
        Time.zone.now
      when 'today'
        Date.today
      when 'tomorrow'
        Date.today + 1.days
      when 'yesterday'
        Date.today - 1.days
      else
        Time.parse(time)
    end
  end

  def attributes_for(match)
    Hash[match.names.collect { |n| [n.to_sym, match[n]] }]
  end
end
