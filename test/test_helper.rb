ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  def logger
    RAILS_DEFAULT_LOGGER
  end
end