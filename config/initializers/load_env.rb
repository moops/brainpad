env_file = Rails.root.join('config', 'application.yml')
if File.exist?(env_file)
  YAML.safe_load(File.open(env_file)).each do |env, keys|
    next unless Rails.env == env
    keys.each do |key, value|
      ENV[key.to_s] = value
    end
  end
end
