path = File.join(Rails.root, "config/twilio.yml")
begin
  TWILIO_CONFIG = YAML.load(File.read(path))[Rails.env]
rescue
  TWILIO_CONFIG = {'sid' => ENV['TWILIO_SID'], 'from' => ENV['TWILIO_FROM'], 'token' => ENV['TWILIO_TOKEN']}
end