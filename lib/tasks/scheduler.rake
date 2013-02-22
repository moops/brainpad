desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  # Instantiate a Twilio client
  client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

  Person.ne(phone: nil).each do |person|
    # Create and send an SMS message
    puts "sending sms to #{person.username}..."
    client.account.sms.messages.create(
      from: TWILIO_CONFIG['from'],
      to: person.phone,
      body: "#{person.username}: this is a test from the send_reminders rake task."
    )
  end
  puts "done send_reminders."
end