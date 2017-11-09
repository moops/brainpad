source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'
gem 'rails', '5.1.4'

gem 'bcrypt'                  # password encryption
gem 'bootstrap'
gem 'bson_ext'                # for mongodb
gem 'jbuilder'                # https://github.com/rails/jbuilder
gem 'jquery-rails'            # unobtrusive javascript
gem 'json'                    # json api
gem 'kaminari'                # pagination
gem 'kaminari-mongoid'
gem 'mongoid'                 # mongodb
gem 'pundit'                  # authorization
gem 'sass-rails'
gem 'uglifier'                # javascript compressor

# external apis
gem 'redd'                    # test reddit client
gem 'strava-api-v3'           # strava access
gem 'twilio-ruby'             # sms sending

group :test do
  gem 'factory_bot_rails'
  gem 'minitest-spec-rails'
  gem 'rails-controller-testing' # not sure if this is needed anymore
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rubocop', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end
