ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

module LoginHelper
  def login(user)
    # p "logging in: #{sessions_path(username: user.username, password: 'adam_pass')}"
    post sessions_path(username: user.username, password: "#{user.username}_pass")
    # p "logged in as: #{session[:user_id]}"
    # p "notices: #{flash[:notice].inspect}"
  end
end

class ActionDispatch::IntegrationTest
  include FactoryGirl::Syntax::Methods
  include LoginHelper
end
