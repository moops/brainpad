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
    p 'parse_workout'
  end

  def parse_journal(person, body)
    p 'parse_journal'
  end

  def parse_payment(person, body)
    'parse_payment'
  end

  def parse_time(time)
    case time.downcase
      when 'today'
        Time.zone.now
      when 'tomorrow'
        Time.zone.now + 1.days
      when 'yesterday'
        Time.zone.now - 1.days
      else
        Time.parse(time)
    end
  end
end
