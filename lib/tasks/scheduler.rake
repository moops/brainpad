desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  # Instantiate a Twilio client
  client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

  Person.ne(phone: nil).each do |person|
    unless Reminder.due_on_for(person).empty?
      # Create and send an SMS message
      puts "sending sms to #{person.username}..."
      client.account.sms.messages.create(
        from: TWILIO_CONFIG['from'],
        to: person.phone,
        body: Reminder.describe_due(person)
      )
    else
      puts "nothing due for #{person.username}..."
    end
  end
  puts "done send_reminders."
end