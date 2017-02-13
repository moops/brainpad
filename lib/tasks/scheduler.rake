desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  # Instantiate a Twilio client
  client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

  p '##########################################################'
  p "sending reminders for #{Date.today}"
  p '##########################################################'
  Person.ne(phone: nil).each do |person|
    unless Reminder.todays(person).empty?
      # Create and send an SMS message
      p "sending sms to #{person.username} (#{person.phone})..."
      client.account.messages.create(
        from: TWILIO_CONFIG['from'],
        to: person.phone,
        body: Reminder.describe_due(person)
      )
    else
      p "nothing due for #{person.username}..."
    end
  end
  p "done send_reminders."
end