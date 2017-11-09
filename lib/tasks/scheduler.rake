desc 'This task is called by the Heroku scheduler add-on'

task send_reminders: :environment do
  # Instantiate a Twilio client
  client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
  Rails.logger.info client.inspect

  p '##########################################################'
  p "sending reminders for #{Time.zone.today}"
  p '##########################################################'
  Person.ne(phone: nil).each do |person|
    if Reminder.todays(person).present?
      # Create and send an SMS message
      Rails.logger.info "sending sms to #{person.username} (#{person.phone})..."
      client.api.account.messages.create(
        from: TWILIO_CONFIG['from'],
        to: person.phone,
        body: Reminder.describe_due(person)
      )
    else
      Rails.logger.info "nothing due for #{person.username}..."
    end
  end
  Rails.logger.info 'done send_reminders.'
end
