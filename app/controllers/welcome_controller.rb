class WelcomeController < ApplicationController
  skip_after_filter :store_last_good_page
  
  # GET /welcome
  def index
  end
end
