class SmsController < ApplicationController
  protect_from_forgery except: :create
  # POST /sms
  def create
    person = Person.find_by(phone: params[:From])
    head :unprocessable_entity unless person
    msg = ''
    begin
      record = create_something(person, params[:Body])
      msg = record.new_record? ? "failed to create #{record.class.name.downcase}" : "created #{record.class.name.downcase} - #{record}"
    rescue StandardError => e
      msg = "failed to create anything: #{e.message}"
    end

    twiml = Twilio::TwiML::Response.new do |r|
      logger.info msg
      r.Message msg
    end
    render xml: twiml.text
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
    m = /^\w+\s+(.*)(on:\s+(.*))$/.match(body)
    due_at = parse_time(m[3])
    person.reminders.create(description: m[1].strip, due_at: due_at)
  end

  def parse_workout(person, body)
    m = /^\w+\s+(?<tags>\w+)\s+(?<location>.*)\s+duration:\s+(?<duration>.*)\s+distance:\s+(?<distance>.*)\s+intensity:\s+(?<intensity>.*)\s+on:\s+(?<workout_on>.*)$/.match(body)
    attributes = attributes_for(m)
    # parse the workout_on
    attributes[:workout_on] = parse_time(attributes[:workout_on])
    person.workouts.create(attributes)
  end

  def parse_journal(person, body)
    m = /^\w+\s+(?<entry>.*)\s+on:\s+(?<entry_on>.*)$/.match(body)
    attributes = attributes_for(m)
    # parse the entry_on
    attributes[:entry_on] = parse_time(attributes[:entry_on])
    person.journals.create(attributes)
  end

  def parse_payment(person, body)
    m = /^\w+\s+(?<tags>[\w-]+)\s+\$(?<amount>\d+(\.\d{1,2})?)\s+(?<description>.*)\s+from:\s+(?<from_account>.*)\s+on:\s+(?<payment_on>.*)/.match(body)
    attributes = attributes_for(m)
    # find the from account
    attributes[:from_account] = person.accounts.find_by(name: /#{attributes[:from_account]}/) if attributes[:from_account]
    # parse the payment_on
    attributes[:payment_on] = parse_time(attributes[:payment_on])
    payment = person.payments.create(attributes)
    payment.apply
    payment
  end

  def parse_time(time)
    return unless time
    case time.downcase
    when 'now'
      Time.zone.now
    when 'today'
      Time.zone.today
    when 'tomorrow'
      Time.zone.today + 1.day
    when 'yesterday'
      Time.zone.today - 1.day
    else
      Time.zone.parse(time)
    end
  end

  def attributes_for(match)
    Hash[match.names.collect { |n| [n.to_sym, match[n]] }]
  end
end
