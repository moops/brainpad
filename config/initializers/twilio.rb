path = Rails.root.join('config', 'twilio.yml')
begin
  TWILIO_CONFIG = YAML.safe_load(File.read(path))[Rails.env]
rescue StandardError
  TWILIO_CONFIG = { 'sid' => ENV['TWILIO_SID'], 'from' => ENV['TWILIO_FROM'], 'token' => ENV['TWILIO_TOKEN'] }.freeze
end
